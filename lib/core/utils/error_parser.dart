import 'package:dio/dio.dart';

class ErrorParser {
  /// Extract user-friendly error message from API response or exception
  static String parseError(dynamic error) {
    try {
      print('🔍 parseError called with: ${error.runtimeType}'); // Debug log

      // If it's a DioException
      if (error is DioException) {
        print('  → DioException detected'); // Debug log
        return _parseDioException(error);
      }

      // If it's a Response object
      if (error is Response) {
        print('  → Response object detected'); // Debug log

        // Check for specific status codes
        try {
          final statusCode = error.statusCode ?? 0;

          // Handle Unauthorized (401) - auth failure
          if (statusCode == 401) {
            print('    → 401 Unauthorized detected'); // Debug log
            return _handleUnauthorizedError(error.data);
          }

          // Handle Forbidden (403)
          if (statusCode == 403) {
            print('    → 403 Forbidden detected'); // Debug log
            return 'Access denied. Please contact support.';
          }

          // Handle Not Found (404)
          if (statusCode == 404) {
            print('    → 404 Not Found detected'); // Debug log
            return 'The requested resource was not found.';
          }

          // Handle server errors (5xx status codes)
          if (statusCode >= 500) {
            print('    → Server error: $statusCode'); // Debug log
            return 'Server error. Please try again later.';
          }
        } catch (e) {
          print('    → Could not check status code: $e');
        }

        return _parseResponseData(error.data);
      }

      // If it's a string
      if (error is String) {
        print('  → String detected'); // Debug log
        return _parseErrorString(error);
      }

      // Handle any Exception type
      if (error is Exception) {
        print('  → Exception detected: ${error.runtimeType}'); // Debug log
        return _handleException(error);
      }

      // Default fallback - try to extract useful info from toString()
      print('  → Default fallback'); // Debug log
      final errorStr = error.toString();

      // Check if error string contains auth-related keywords
      if (errorStr.toLowerCase().contains('unauthorized') ||
          errorStr.toLowerCase().contains('invalid') ||
          errorStr.toLowerCase().contains('401')) {
        return 'Invalid email or password. Please try again.';
      }

      if (errorStr.toLowerCase().contains('forbidden') ||
          errorStr.toLowerCase().contains('403')) {
        return 'Access denied. Please contact support.';
      }

      return errorStr;
    } catch (e, stackTrace) {
      print('❌ Error in parseError: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log
      return 'An error occurred. Please try again.';
    }
  }

  /// Handle generic exceptions
  static String _handleException(Exception error) {
    try {
      print('  → Exception type: ${error.runtimeType}'); // Debug log

      // Handle NoSuchMethodError specifically (common on web platform)
      if (error is NoSuchMethodError) {
        print(
          '  → NoSuchMethodError detected (web platform error)',
        ); // Debug log
        final errorString = error.toString().toLowerCase();

        // Check if it might be related to auth failure
        if (errorString.contains('401') ||
            errorString.contains('unauthorized') ||
            errorString.contains('invalid')) {
          return 'Invalid email or password. Please try again.';
        }

        return 'An error occurred. Please try again.';
      }

      final errorString = error.toString();
      print('  → Exception string: $errorString'); // Debug log

      if (errorString.contains('Duplicate entry')) {
        return _parseDuplicateError(errorString);
      }
      if (errorString.contains('SQLSTATE')) {
        return _parseSQLError(errorString);
      }
      if (errorString.contains('500')) {
        return 'Server error. Please try again later.';
      }
      if (errorString.contains('Unauthorized') ||
          errorString.contains('unauthorized')) {
        return 'Invalid email or password. Please try again.';
      }
      if (errorString.contains('401')) {
        return 'Invalid email or password. Please try again.';
      }

      return errorString;
    } catch (e, stackTrace) {
      print('  → Error handling exception: $e'); // Debug log
      print('  → Stack trace: $stackTrace');
      return 'An unexpected error occurred.';
    }
  }

  /// Parse DioException to extract meaningful error message
  static String _parseDioException(DioException error) {
    try {
      print('  → DioException details:'); // Debug log

      // Safely print properties without triggering errors
      try {
        print('    - Status: ${error.response?.statusCode}');
        print('    - Data: ${error.response?.data}');
      } catch (e) {
        print('    - (Could not access response properties)');
      }
      print('    - Message: ${error.message}'); // Debug log

      // Try to get error from response data first if available
      if (error.response != null && error.response!.data != null) {
        try {
          final responseMsg = _parseResponseData(error.response!.data);
          if (responseMsg.isNotEmpty &&
              responseMsg != 'Unknown error occurred' &&
              !responseMsg.startsWith('Instance of')) {
            print('    → Extracted response message: $responseMsg');
            return responseMsg;
          }
        } catch (e) {
          print('    → Error accessing response data: $e');
        }
      }

      // Check status code for fallback specific handling
      try {
        final statusCode = error.response?.statusCode;

        print('    → Status code check: $statusCode'); // Debug log

        if (statusCode != null) {
          // Handle Unauthorized (401) - auth failure
          if (statusCode == 401) {
            print('    → 401 Unauthorized detected'); // Debug log
            return _handleUnauthorizedError(error.response?.data);
          }

          // Handle Forbidden (403)
          if (statusCode == 403) {
            print('    → 403 Forbidden detected'); // Debug log
            return 'Access denied. Please contact support.';
          }

          // Handle Not Found (404)
          if (statusCode == 404) {
            print('    → 404 Not Found detected'); // Debug log
            return 'The requested resource was not found.';
          }

          // Handle server errors (5xx)
          if (statusCode >= 500) {
            print('    → Server error: $statusCode'); // Debug log
            return 'Server error occurred. Please try again later.';
          }
        }
      } catch (e) {
        print('    → Error checking status code: $e');
      }

      // If response message exists
      if (error.response != null) {
        try {
          if (error.response?.statusMessage != null) {
            print('    → Using status message'); // Debug log
            return error.response!.statusMessage ?? 'Unknown error';
          }
        } catch (e) {
          print('    → Error accessing status message: $e');
        }
      }

      // Fallback for connection errors
      print('    → Using error message'); // Debug log
      final message = error.message ?? 'Connection error';

      // Check message for auth keywords
      if (message.toLowerCase().contains('unauthorized') ||
          message.toLowerCase().contains('401')) {
        return 'Invalid email or password. Please try again.';
      }

      return message;
    } catch (e) {
      print('    → Error in _parseDioException: $e'); // Debug log
      return 'An error occurred. Please try again.';
    }
  }

  /// Handle 401 Unauthorized errors and extract meaningful messages
  static String _handleUnauthorizedError(dynamic responseData) {
    try {
      if (responseData is Map<String, dynamic>) {
        if (responseData['error'] != null) {
          final error = responseData['error'];
          final errorStr = error.toString().toLowerCase();

          // Provide user-friendly messages for specific auth errors
          if (errorStr.contains('unauthorized') ||
              errorStr.contains('invalid')) {
            return 'Invalid email or password. Please try again.';
          }
          if (errorStr.contains('credential')) {
            return 'Invalid credentials. Please check your email and password.';
          }
          if (errorStr.contains('expired')) {
            return 'Your session has expired. Please login again.';
          }

          // Return the error as-is if it's something else
          return error.toString();
        }

        if (responseData.containsKey('message') &&
            responseData['message'] != null) {
          return responseData['message'].toString();
        }
      }

      // Default message for 401
      return 'Invalid email or password. Please try again.';
    } catch (e) {
      print('    → Error in _handleUnauthorizedError: $e'); // Debug log
      return 'Invalid email or password. Please try again.';
    }
  }

  /// Parse response data to extract error message and format it nicely
  static String _parseResponseData(dynamic data) {
    try {
      print('  → parseResponseData: $data'); // Debug log

      if (data == null) return 'Unknown error occurred';

      if (data is Map<String, dynamic>) {
        print('    → Map data detected'); // Debug log
        // Try common error field names
        if (data.containsKey('message') && data['message'] != null) {
          print('    → Found "message" key'); // Debug log
          return _formatErrorMessage(data['message']);
        }
        if (data.containsKey('error') && data['error'] != null) {
          print('    → Found "error" key'); // Debug log
          return _formatErrorMessage(data['error']);
        }
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map<String, dynamic>) {
            final firstErrorKey = errors.keys.first;
            final errorValue = errors[firstErrorKey];
            if (errorValue is List && errorValue.isNotEmpty) {
              return _formatErrorMessage(errorValue.first);
            }
            return _formatErrorMessage(errorValue);
          } else if (errors is List && errors.isNotEmpty) {
            return _formatErrorMessage(errors.first);
          }
        }
      }

      if (data is String) {
        print('    → String data detected'); // Debug log
        return _parseErrorString(data);
      }

      print('    → Fallback toString'); // Debug log
      final dataStr = data.toString();
      if (dataStr.contains('Duplicate entry')) {
        return _parseDuplicateError(dataStr);
      }
      return dataStr;
    } catch (e) {
      print('  → Error in _parseResponseData: $e'); // Debug log
      return 'An error occurred processing the response.';
    }
  }

  /// Parse error string and extract meaningful information
  static String _parseErrorString(String errorString) {
    try {
      if (errorString.isEmpty) {
        return 'An error occurred. Please try again.';
      }

      // Handle SQL duplicate entry errors (check this first as it's inside SQLSTATE errors)
      if (errorString.contains('Duplicate entry')) {
        return _parseDuplicateError(errorString);
      }

      // Handle other SQLSTATE errors
      if (errorString.contains('SQLSTATE')) {
        // If it contains SQLSTATE but we already checked for duplicates, check again to be sure
        if (errorString.contains('Duplicate entry')) {
          return _parseDuplicateError(errorString);
        }
        return _parseSQLError(errorString);
      }

      // Clean up Instance of 'Response' messages
      if (errorString.contains('Instance of')) {
        return 'An error occurred. Please try again.';
      }

      return errorString;
    } catch (e) {
      print('  → Error in _parseErrorString: $e'); // Debug log
      return 'An error occurred while processing the error message.';
    }
  }

  /// Extract duplicate entry information and format it nicely
  /// Expected format: "SQLSTATE[23000]: Integrity constraint violation: 1062 Duplicate entry 'value' for key 'field'"
  static String _parseDuplicateError(String errorString) {
    try {
      if (errorString.isEmpty) {
        return 'This entry already exists.';
      }

      // Look for 'Duplicate entry' pattern
      final duplicateRegex = RegExp(
        r"Duplicate entry '([^']*)' for key '([^']*)'",
      );
      final match = duplicateRegex.firstMatch(errorString);

      if (match != null) {
        final value = match.group(1)?.trim() ?? '';
        final field = match.group(2)?.trim() ?? 'field';

        if (value.isEmpty) {
          return 'This entry already exists. Please use a different one.';
        }

        // Make field name more user-friendly
        final friendlyFieldName = _formatFieldName(field);
        final message =
            "'$value' is already registered as a $friendlyFieldName. Please use a different one.";
        print('✓ Parsed duplicate error: $message'); // Debug log
        return message;
      }
    } catch (e) {
      print('✗ Error parsing duplicate entry: $e'); // Debug log
    }

    return 'This entry already exists. Please use a different one.';
  }

  /// Parse SQL errors and provide user-friendly messages
  static String _parseSQLError(String errorString) {
    try {
      if (errorString.isEmpty) {
        return 'A database error occurred.';
      }

      if (errorString.contains('not found')) {
        return 'The requested item was not found.';
      }
      if (errorString.contains('Integrity constraint violation')) {
        return 'This entry violates data integrity. Please check your information and try again.';
      }
      return 'A database error occurred. Please try again.';
    } catch (e) {
      print('  → Error in _parseSQLError: $e'); // Debug log
      return 'A database error occurred.';
    }
  }

  /// Format error message to be more user-friendly
  static String _formatErrorMessage(dynamic message) {
    try {
      if (message == null) return 'Unknown error occurred';

      String messageStr = message.toString();

      // Clean up the message
      if (messageStr.contains('Duplicate entry')) {
        return _parseDuplicateError(messageStr);
      }
      if (messageStr.contains('SQLSTATE')) {
        return _parseSQLError(messageStr);
      }

      return messageStr;
    } catch (e) {
      print('  → Error in _formatErrorMessage: $e'); // Debug log
      return 'An error occurred processing the message.';
    }
  }

  /// Convert database field names to user-friendly names
  static String _formatFieldName(String fieldName) {
    final fieldMap = {
      'users_username_unique': 'username',
      'users_email_unique': 'email',
      'email': 'email',
      'username': 'username',
      'full_name': 'full name',
      'fullname': 'full name',
      'mobile_phone': 'phone number',
      'id_number': 'ID number',
      'id_passport_number': 'ID/Passport number',
      'nationality': 'nationality',
      'address': 'address',
    };

    return fieldMap[fieldName] ?? fieldName;
  }
}
