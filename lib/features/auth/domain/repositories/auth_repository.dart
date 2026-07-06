import 'package:go2car/core/utils/typedefs.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  FutureEither<UserEntity> login({
    required String email,
    required String password,
  });

  FutureVoid register({
    required String email,
    required String password,
    required String name,
    required String userType,
  });

  FutureVoid logout();

  FutureEither<UserEntity> loginAsGuest({required String userType});
}
