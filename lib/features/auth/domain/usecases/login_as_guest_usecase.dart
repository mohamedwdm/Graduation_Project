import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/auth/domain/repositories/auth_repository.dart';

class LoginAsGuestUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  LoginAsGuestUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await _repository.loginAsGuest();
  }
}
