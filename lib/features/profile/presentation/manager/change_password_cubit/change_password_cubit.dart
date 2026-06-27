import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
      : super(ChangePasswordInitial());

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(ChangePasswordLoading());
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
