import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/core/utils/storge_helper.dart';
import 'package:templet/features/auth_screen/cubit/auth_state.dart';
import 'package:templet/features/auth_screen/models/login_failure.dart';
import 'package:templet/features/auth_screen/models/login_response_model.dart';
import 'package:templet/features/auth_screen/models/user_model.dart';
import 'package:templet/features/auth_screen/models/user_unit_model.dart';
import 'package:templet/features/auth_screen/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());
  final AuthRepo _authRepo;

  void login({
    required String email,
    required String password,
    // Forced first-login reset: resubmit the SAME login with the temporary
    // password plus the user's chosen replacement as [newPassword].
    String? newPassword,
  }) async {
    emit(AuthLoadingState());
    final Either<LoginFailure, LoginResponseModel> res = await _authRepo.login(
      email,
      password,
      newPassword: newPassword,
    );

    res.fold(
      (failure) {
        if (isClosed) return;
        if (failure.resetRequired) {
          emit(
            AuthPasswordResetRequiredState(
              failure.message,
              newPasswordMustDiffer: failure.newPasswordMustDiffer,
            ),
          );
        } else {
          print(
            '🔐 AuthCubit: Emitting error state. Error: ${failure.message}',
          );
          emit(AuthErrorState(failure.message));
        }
      },
      (right) {
        print('🔐 AuthCubit: Emitting success state');
        if (!isClosed) {
          emit(AuthSuccessState("Login Successfully", loginResponse: right));
        }
      },
    );
  }

  Future<void> getUserAcc() async {
    emit(AuthLoadingState());
    final Either<String, UserModel> res = await _authRepo.getUserAcc();

    res.fold(
      (error) {
        if (!isClosed) emit(AuthErrorState(error));
      },
      (right) {
        if (!isClosed) emit(AccUserSuccessState(right));
      },
    );
  }

  Future<void> getAllUsers() async {
    emit(AuthLoadingState());
    final Either<String, List<UserModel>> res = await _authRepo.getAllUsers();

    res.fold(
      (error) {
        if (!isClosed) emit(AuthErrorState(error));
      },
      (users) {
        if (!isClosed) emit(AllUsersSuccessState(users));
      },
    );
  }

  void updateUser({
    required int id,
    required String name,
    required String password,
    required String email,
  }) async {
    emit(AuthLoadingState());
    final Either<String, UserUnitModel> res = await _authRepo.updateUser(
      id.toString(),
      name,
      email,
      password,
    );

    res.fold(
      (error) {
        if (!isClosed) emit(AuthErrorState(error));
      },
      (right) {
        if (!isClosed) emit(AuthUpdateUserSuccessState(right));
      },
    );
  }

  void Logout() {
    sl<StorgeHelper>().deleteToken();
  }

  void register({
    required String name,
    required String email,
    required String password,
    String? passwordConfirmation,
    String? role,
  }) async {
    emit(AuthLoadingState());
    final res = await _authRepo.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      role: role,
    );

    res.fold(
      (error) {
        if (!isClosed) emit(AuthErrorState(error));
      },
      (loginResponse) {
        if (!isClosed) {
          emit(
            AuthSuccessState(
              "Account registered successfully",
              loginResponse: loginResponse,
            ),
          );
        }
      },
    );
  }
}
