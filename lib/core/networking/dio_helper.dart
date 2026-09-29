import 'dart:developer';
import 'package:dio/dio.dart';

import 'package:templet/core/networking/api_endpoints.dart';

class DioHelper {
  Dio? dio;
  Future<void> Function()? _onUnauthorized;
  bool _isHandlingUnauthorized = false;

  DioHelper() {
    dio ??= Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
    dio!.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          await _handleUnauthorizedResponse(response);
          handler.next(response);
        },
        onError: (error, handler) async {
          await _handleUnauthorizedResponse(error.response);
          handler.next(error);
        },
      ),
    );
  }

  void setUnauthorizedHandler(Future<void> Function() handler) {
    _onUnauthorized = handler;
  }

  Future<void> _handleUnauthorizedResponse(Response<dynamic>? response) async {
    if (_onUnauthorized == null || !_shouldLogout(response)) {
      return;
    }

    if (_isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    try {
      await _onUnauthorized!.call();
    } finally {
      _isHandlingUnauthorized = false;
    }
  }

  /// Ends the session when the server unambiguously rejected the stored token.
  ///
  /// Two cases trigger a logout:
  ///
  ///  1. **HTTP 401** – the canonical "your token is invalid / expired" signal.
  ///     Requests with no usable bearer token are excluded by [_hasAuthHeader]
  ///     so an unauthenticated 401 (e.g. a public endpoint) cannot log out a
  ///     valid session.
  ///
  ///  2. **`{"error": "Token not valid"}`** on any status – some Laravel
  ///     middleware returns HTTP 200 with this body instead of a proper 401.
  ///     We only act on it when the request actually carried a bearer token so
  ///     we cannot be triggered by unrelated responses.
  bool _shouldLogout(Response<dynamic>? response) {
    if (response == null || !_hasAuthHeader(response.requestOptions)) {
      return false;
    }

    // Standard HTTP signal.
    if (response.statusCode == 401) return true;

    // Laravel quirk: 200 OK with {"error": "Token not valid"}.
    final data = response.data;
    if (data is Map) {
      final error = data['error'];
      if (error is String &&
          error.toLowerCase().contains('token not valid')) {
        return true;
      }
    }

    return false;
  }

  /// True only when the request actually carried a usable token.
  ///
  /// The header is built as `'Bearer $token'`, so a caller that passes a null
  /// token stringifies it to the literal `"Bearer null"`. That is not an
  /// authenticated request, and the 401 it earns says nothing about the stored
  /// session — treating it as expiry logged the user out of a valid session
  /// whenever a repo fired before its token had been read. `"Bearer "` (empty
  /// token, what StorgeHelper.getToken returns when absent) is rejected by the
  /// same length check.
  bool _hasAuthHeader(RequestOptions requestOptions) {
    final authHeader =
        requestOptions.headers['Authorization']?.toString() ?? '';
    if (!authHeader.startsWith('Bearer ')) {
      return false;
    }

    final token = authHeader.substring('Bearer '.length).trim();
    return token.isNotEmpty && token != 'null';
  }

  Future<Response<dynamic>> getRequest({
    required String endPoint,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      final headers = <String, dynamic>{
        'Accept': "application/json",
        'Content-Type': "application/json",
      };
      // Only attach an Authorization header when a real token is supplied —
      // same contract as postFileRequest. A null/empty token used to be
      // stringified into the literal "Bearer null"/"Bearer ", which is not an
      // authenticated request; unauthenticated callers (e.g. the signup
      // wizard's public Property→Building→Floor→Unit cascade) now simply send
      // no header at all, keeping them out of reach of
      // _hasAuthHeader/_shouldLogout. Callers with a stored token are
      // unchanged.
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      Response response = await dio!.get(
        endPoint,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> postRequest({
    required String endPoint,
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await dio!.post(
        endPoint,
        data: data,
        options: Options(
          headers: {
            'Accept': "application/json",
            'Content-Type': "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow; // Important: rethrow the exception so it can be handled by the caller
    }
  }

  Future<Response<dynamic>> postRequestWithoutToken({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await dio!.post(
        endPoint,
        data: data,
        options: Options(
          headers: {
            'Accept': "application/json",
            'Content-Type': "application/json",
          },
        ),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow; // Important: rethrow the exception so it can be handled by the caller
    }
  }

  Future<Response<dynamic>> postFileRequest({
    required String endPoint,
    String? token,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Never log field VALUES or token material here: this method carries
      // the registration wizard's multipart payload (password, national ID,
      // name, phone — real residents' PII). Keys only.
      print('📤 postFileRequest: Endpoint: $endPoint');
      print(
        '📤 postFileRequest: Token: '
        '${token != null && token.isNotEmpty ? 'present' : 'none (unauthenticated request)'}',
      );
      print('📤 postFileRequest: Data keys: ${data.keys.toList()}');

      final headers = <String, dynamic>{
        'Accept': "application/json",
        'Content-Type': "multipart/form-data",
      };
      // Only attach an Authorization header when a real token is supplied.
      // Omitting it (rather than sending "Bearer null"/"Bearer ") keeps
      // unauthenticated requests (e.g. public registration endpoints) out of
      // reach of _hasAuthHeader/_shouldLogout, which only ever consider
      // responses to requests that actually carried a Bearer token.
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      Response response = await dio!.post(
        endPoint,
        data: FormData.fromMap(data),
        options: Options(headers: headers),
      );

      print('✅ postFileRequest Success: Status ${response.statusCode}');
      return response;
    } catch (e) {
      log('❌ postFileRequest Error: ${e.toString()}');

      if (e is DioException) {
        // Status + endpoint only — the request body holds the submitted
        // password/PII and the response body can echo submitted values.
        print('❌ DioException Details:');
        print('   Status Code: ${e.response?.statusCode}');
        print('   Endpoint: ${e.requestOptions.path}');
      }

      rethrow;
    }
  }

  Future<Response<dynamic>> putRequest({
    required String endPoint,
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await dio!.put(
        endPoint,
        data: data,
        options: Options(
          headers: {
            'Accept': "application/json",
            'Content-Type': "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Response<dynamic>> deleteRequest({
    required String endPoint,
    required String token,
    Map<String, dynamic>? data,
  }) async {
    try {
      Response response = await dio!.delete(
        endPoint,
        data: data,
        options: Options(
          headers: {
            'Accept': "application/json",
            'Content-Type': "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
