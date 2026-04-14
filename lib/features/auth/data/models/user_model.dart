import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/core/utils/typedefs.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userid,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(JsonMap json) {
    return UserModel(
      userid: json['userid']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userid: entity.userid,
      name: entity.name,
      email: entity.email,
    );
  }

  JsonMap toJson() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
    };
  }
}
