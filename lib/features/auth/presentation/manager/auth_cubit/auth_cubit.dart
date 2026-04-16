import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/auth/domain/usecases/login_usecase.dart';
import 'package:go2car/features/auth/domain/usecases/register_usecase.dart';
import 'package:go2car/features/auth/domain/usecases/logout_usecase.dart';
import 'package:go2car/features/auth/domain/usecases/login_as_guest_usecase.dart';
import 'package:go2car/core/usecase/usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final LoginAsGuestUseCase _loginAsGuestUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required LoginAsGuestUseCase loginAsGuestUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _loginAsGuestUseCase = loginAsGuestUseCase,
        super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(email: email, password: password, name: name),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const RegisterSuccess()),
    );
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
    emit(const AuthInitial());
  }

  Future<void> loginAsGuest() async {
    emit(const AuthLoading());
    final result = await _loginAsGuestUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
