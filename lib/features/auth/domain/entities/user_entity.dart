import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String role;

  const UserEntity({
    required this.userid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [userid, name, email, role];
}
