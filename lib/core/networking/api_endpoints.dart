import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }
    return "http://127.0.0.1:8000";
  }

  // api auth
  static const String apiLogin = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String forgotPassword = "/api/auth/forgot-password";
  static const String resetPassword = "/api/auth/reset-password";
  static const String profile = "/api/auth/me";
  static const String updateUser = "/api/auth/update/";
  static const String updateUserByadmin = "/api/auth/updateByUser/";
  static const String addUserByAdmin = "/api/auth/adduser";
  static const String getAllUsers = "/api/auth/index";

}
