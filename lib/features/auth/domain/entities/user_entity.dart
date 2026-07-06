import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String role;
  final String userType;

  const UserEntity({
    required this.userid,
    required this.name,
    required this.email,
    required this.role,
    required this.userType,
  });

  bool get isAdmin => role == 'admin';
  bool get isGuest => role == 'guest' || userid == '0' || userid == 'guest_id_from_server';

  @override
  List<Object?> get props => [userid, name, email, role, userType];
}
