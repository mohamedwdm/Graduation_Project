import 'user_model.dart';
import 'package:go2car/core/utils/typedefs.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;

  const AuthResponseModel({
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(JsonMap json) {
    return AuthResponseModel(
      token: json['token']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] as JsonMap? ?? json),
    );
  }
}
