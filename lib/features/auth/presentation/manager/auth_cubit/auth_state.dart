part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


final class RegisterSuccess extends AuthState {}

final class RegisterLoading extends AuthState {}

final class RegisterFailure extends AuthState {
  final String errorMessege;

  RegisterFailure({required this.errorMessege});
}

final class LoginSuccess extends AuthState {
  final UserModel user;

  LoginSuccess({required this.user});
}

final class LoginLoading extends AuthState {}

final class LoginFailure extends AuthState {
  final String errorMessege;

  LoginFailure({required this.errorMessege});
}
