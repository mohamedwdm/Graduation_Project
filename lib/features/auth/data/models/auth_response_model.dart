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
    final tokenData = json['token'];
    String tokenStr = '';
    if (tokenData is Map) {
      tokenStr = tokenData['access_token']?.toString() ?? '';
    } else {
      tokenStr = json['access_token']?.toString() ?? json['token']?.toString() ?? '';
    }
    return AuthResponseModel(
      token: tokenStr,
      user: UserModel.fromJson(json['user'] as JsonMap? ?? json),
    );
  }
}
