import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/failure.dart';
import 'package:go2car/features/auth/data/models/user_model.dart';


abstract class UserRepo {
  Future<Either<Failure , void>> registerUser({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure , UserModel>> loginUser({required String email, required String password});
  Future<void> logOut();
}
