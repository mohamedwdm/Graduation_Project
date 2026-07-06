import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/core/utils/typedefs.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userid,
    required super.name,
    required super.email,
    required super.role,
    required super.userType,
  });

  factory UserModel.fromJson(JsonMap json) {
    final userid = json['userid']?.toString() ?? json['id']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final role = (userid == '0' || name == 'Guest' || json['role'] == 'guest')
        ? 'guest'
        : (json['role']?.toString() ?? 
            ((json['is_admin'] == true) ? 'admin' : 'user'));
    final userType = json['user_type']?.toString() ?? 'normal';

    return UserModel(
      userid: userid,
      name: name,
      email: json['email']?.toString() ?? '',
      role: role,
      userType: userType,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userid: entity.userid,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      userType: entity.userType,
    );
  }

  JsonMap toJson() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'role': role,
      'user_type': userType,
    };
  }
}
