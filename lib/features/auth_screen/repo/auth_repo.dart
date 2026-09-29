import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:templet/core/networking/api_endpoints.dart';
import 'package:templet/core/networking/dio_helper.dart';
import 'package:templet/core/utils/error_parser.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/core/utils/storge_helper.dart';
import 'package:templet/features/auth_screen/models/login_failure.dart';
import 'package:templet/features/auth_screen/models/login_response_model.dart';
import 'package:templet/features/auth_screen/models/user_model.dart';
import 'package:templet/features/auth_screen/models/user_unit_model.dart';

class AuthRepo {
  final DioHelper _dioHelper;
  AuthRepo(this._dioHelper);

  Future<Either<LoginFailure, LoginResponseModel>> login(
    String eamil,
    String password, {
    // Forced first-login reset (owner-assisted minor accounts): the server
    // never issues a token while `must_reset_password` is set — the holder
    // proves the temporary `password` and supplies the replacement as
    // `new_password` in the SAME login call.
    String? newPassword,
  }) async {
    try {
      final response = await _dioHelper.postRequestWithoutToken(
        endPoint: ApiEndpoints.apiLogin,
        data: {
          "email": eamil,
          "password": password,
          if (newPassword != null && newPassword.isNotEmpty)
            "new_password": newPassword,
        },
      );

      // Safely check status code
      final statusCode = response.statusCode ?? 0;
      print('🔐 Login Response Status: $statusCode');

      if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
        final loginResponse = LoginResponseModel.fromJson(response.data);
        // final activeValue =
        //     loginResponse.active?.toString().trim().toLowerCase() ?? '';
        // final isActive =
        //     activeValue == '1' ||
        //     activeValue == 'true' ||
        //     activeValue == 'active';

        // if (!isActive && activeValue.isNotEmpty) {
        //   return const Left(
        //     LoginFailure(
        //       'Your account is inactive. Please contact the administrator.',
        //     ),
        //   );
        // }

        await sl<StorgeHelper>().saveToken(
          loginResponse.accessToken,
          loginResponse.name!,
          loginResponse.id.toString(),
          loginResponse.role!,
        );
        return Right(loginResponse);
      } else if (statusCode == 401) {
        // Handle unauthorized specifically
        print('🔐 401 Unauthorized - Invalid credentials');
        return const Left(
          LoginFailure('Invalid email or password. Please try again.'),
        );
      } else {
        final resetFailure = _resetRequiredFailure(response.data);
        if (resetFailure != null) return Left(resetFailure);
        return Left(LoginFailure(ErrorParser.parseError(response)));
      }
    } on DioException catch (error) {
      print('🔐 Login DioException caught!');
      print('🔐 Status Code from DioException: ${error.response?.statusCode}');
      print('🔐 Type: ${error.type}');

      // Check if it's a 401 Unauthorized from DioException
      final statusCode = error.response?.statusCode ?? 0;
      if (statusCode == 401) {
        print('🔐 DioException 401 - Invalid credentials');
        return const Left(
          LoginFailure('Invalid email or password. Please try again.'),
        );
      }

      // Dio throws for non-2xx by default, so the forced-reset 403/422
      // normally arrive here rather than as a returned response.
      final resetFailure = _resetRequiredFailure(error.response?.data);
      if (resetFailure != null) return Left(resetFailure);

      // Parse the error properly for other cases
      return Left(LoginFailure(ErrorParser.parseError(error)));
    } catch (error) {
      print('🔐 Unexpected Login Error type: ${error.runtimeType}');

      // Return parsed error
      return Left(LoginFailure(ErrorParser.parseError(error)));
    }
  }

  /// Recognizes the backend's forced-first-login-reset signal
  /// (`AuthController::login`): a non-2xx body carrying
  /// `must_reset_password: true` / `error: password_reset_required`.
  /// `message_key` distinguishes the two cases — `auth.password_reset_required`
  /// (403: send a `new_password`) vs `auth.new_password_must_differ`
  /// (422: the chosen password equals the temporary one).
  static LoginFailure? _resetRequiredFailure(dynamic data) {
    if (data is! Map) return null;
    final flagged =
        data['must_reset_password'] == true ||
        data['error'] == 'password_reset_required';
    if (!flagged) return null;
    return LoginFailure(
      data['message']?.toString() ?? 'You must set a new password.',
      resetRequired: true,
      newPasswordMustDiffer:
          data['message_key'] == 'auth.new_password_must_differ',
    );
  }

  Future<Either<String, UserModel>> getUserAcc() async {
    final value = await sl<StorgeHelper>().getToken();
    if (value == null || value.isEmpty) {
      return Left("No token found");
    }
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.profile,
        token: value,
        data: {},
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        // Profile endpoint likely doesn't return access_token; parse flexible user account data
        final userAccount = UserModel.fromJson(
          response.data is Map<String, dynamic>
              ? response.data
              : <String, dynamic>{},
        );
        log('🔐 User Account Data: ${response.data}');
        return Right(userAccount);
      } else {
        return Left(ErrorParser.parseError(response));
        // log(response.data.toString());
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ErrorParser.parseError(error));
      }
      // log(error.toString());
      return Left(ErrorParser.parseError(error));
    }
  }

  Future<Either<String, UserUnitModel>> updateUser(
    String userId,
    String name,
    String email,
    String password,
  ) async {
    final value = await sl<StorgeHelper>().getToken();
    if (value == null || value.isEmpty) {
      return Left("No token found");
    }
    try {
      final response = await _dioHelper.postRequest(
        endPoint: "${ApiEndpoints.updateUser}$userId",
        data: {"name": name, "email": email, "password": password},
        token: value,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final userUnit = UserUnitModel.fromJson(response.data);
        return Right(userUnit);
      } else {
        return Left(ErrorParser.parseError(response));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ErrorParser.parseError(error));
      }
      return Left(ErrorParser.parseError(error));
    }
  }

  void Logout() {
    sl<StorgeHelper>().deleteToken();
  }

  Future<Either<String, String>> forgotPassword(String email) async {
    try {
      final response = await _dioHelper.postRequestWithoutToken(
        endPoint: ApiEndpoints.forgotPassword,
        data: {"email": email},
      );
      if (response.statusCode == 200) {
        return Right(response.data['message'] ?? 'Reset code sent.');
      }
      return Left(ErrorParser.parseError(response));
    } catch (error) {
      return Left(ErrorParser.parseError(error));
    }
  }

  Future<Either<String, String>> resetPassword(
    String email,
    String token,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _dioHelper.postRequestWithoutToken(
        endPoint: ApiEndpoints.resetPassword,
        data: {
          "email": email,
          "token": token,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );
      if (response.statusCode == 200) {
        return Right(
          response.data['message'] ?? 'Password reset successfully.',
        );
      }
      return Left(ErrorParser.parseError(response));
    } catch (error) {
      return Left(ErrorParser.parseError(error));
    }
  }

  Future<Either<String, LoginResponseModel>> register({
    required String name,
    required String email,
    required String password,
    String? passwordConfirmation,
    String? role,
  }) async {
    try {
      final response = await _dioHelper.postRequestWithoutToken(
        endPoint: ApiEndpoints.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation ?? password,
          if (role != null && role.isNotEmpty) "role": role,
        },
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
        if (response.data is Map<String, dynamic> &&
            response.data['access_token'] != null) {
          final loginResponse = LoginResponseModel.fromJson(response.data);
          await sl<StorgeHelper>().saveToken(
            loginResponse.accessToken,
            loginResponse.name ?? name,
            loginResponse.id?.toString() ?? '',
            loginResponse.role ?? role ?? 'user',
          );
          return Right(loginResponse);
        }
        return Right(
          LoginResponseModel(
            accessToken: '',
            name: name,
            role: role ?? 'user',
          ),
        );
      } else {
        return Left(ErrorParser.parseError(response));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ErrorParser.parseError(error));
      }
      return Left(ErrorParser.parseError(error));
    }
  }

  Future<Either<String, List<UserModel>>> getAllUsers() async {
    final value = await sl<StorgeHelper>().getToken();
    if (value == null || value.isEmpty) {
      return const Left("No token found");
    }
    try {
      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.getAllUsers,
        token: value,
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
        final raw = response.data;
        List<dynamic> jsonList = [];
        if (raw is List) {
          jsonList = raw;
        } else if (raw is Map<String, dynamic>) {
          if (raw['data'] is List) {
            jsonList = raw['data'] as List<dynamic>;
          } else if (raw['users'] is List) {
            jsonList = raw['users'] as List<dynamic>;
          } else if (raw.containsKey('message') && raw['data'] == null) {
            return Left(raw['message'].toString());
          } else {
            jsonList = [raw];
          }
        }
        final users = jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => UserModel.fromJson(item))
            .toList();
        return Right(users);
      } else {
        return Left(ErrorParser.parseError(response));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ErrorParser.parseError(error));
      }
      return Left(ErrorParser.parseError(error));
    }
  }
}
