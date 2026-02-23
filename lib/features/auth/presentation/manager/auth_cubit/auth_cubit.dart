import 'package:bloc/bloc.dart';
import 'package:go2car/features/auth/data/models/user_model.dart';
import 'package:go2car/features/auth/data/repos/user_repo.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.userRepo) : super(AuthInitial());

  final UserRepo userRepo;

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(RegisterLoading());
    var result = await userRepo.registerUser(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) {
        emit(RegisterFailure(errorMessege: failure.errorMessage));
      },
      (_) {
        emit(RegisterSuccess());
      },
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    var result = await userRepo.loginUser(email: email, password: password);
    result.fold(
      (failure) {
        emit(LoginFailure(errorMessege: failure.errorMessage));
      },
      (user) {
        emit(LoginSuccess(user: user));
      },
    );
  }

  Future<void> logOut() async {
    await userRepo.logOut();
  }
}
