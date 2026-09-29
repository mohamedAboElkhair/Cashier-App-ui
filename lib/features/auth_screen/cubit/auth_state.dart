

import 'package:templet/features/auth_screen/models/login_response_model.dart';
import 'package:templet/features/auth_screen/models/user_account_model.dart';
import 'package:templet/features/auth_screen/models/user_model.dart';
import 'package:templet/features/auth_screen/models/user_unit_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;
  AuthErrorState(this.errorMessage);
}

class AuthSuccessState extends AuthState {
  final String message;
  // Carries the parsed login payload so the login screen can decide whether to
  // route through the terms re-agree gate before entering the main app.
  final LoginResponseModel? loginResponse;
  AuthSuccessState(this.message, {this.loginResponse});
}

/// The server refused to issue a token because the account still carries the
/// `must_reset_password` flag (owner-assisted minor accounts get a temporary
/// password). The login screen switches into set-new-password mode and
/// resubmits the same login call with `new_password` alongside the temporary
/// password. [newPasswordMustDiffer] marks the 422 sub-case (the chosen new
/// password equals the temporary one) so it can be shown inline on the field.
class AuthPasswordResetRequiredState extends AuthState {
  final String message;
  final bool newPasswordMustDiffer;
  AuthPasswordResetRequiredState(
    this.message, {
    this.newPasswordMustDiffer = false,
  });
}

class AuthGetUserSuccessState extends AuthState {
  final UserAccountModel user;
  AuthGetUserSuccessState(this.user);
}
class AccUserSuccessState extends AuthState {
  final UserModel user;
  AccUserSuccessState(this.user);
}

class AllUsersSuccessState extends AuthState {
  final List<UserModel> users;
  AllUsersSuccessState(this.users);
}

class AuthRegisterSuccessState extends AuthState {
  final UserUnitModel userUnit;
  AuthRegisterSuccessState(this.userUnit);
}

/// Registration-specific failure carrying the backend's per-field validation
/// errors (e.g. a duplicate-username 422's `errors.username`) so the signup
/// wizard can surface each message inline on its own field, and only fall
/// back to a general surface for non-field problems.
class AuthRegisterErrorState extends AuthState {
  final String errorMessage;
  final Map<String, String> fieldErrors;
  AuthRegisterErrorState(this.errorMessage, {this.fieldErrors = const {}});
}

class AuthUpdateUserSuccessState extends AuthState {
  final UserUnitModel userUnit;
  AuthUpdateUserSuccessState(this.userUnit);
}
