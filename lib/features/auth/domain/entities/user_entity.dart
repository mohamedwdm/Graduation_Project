import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userid;
  final String name;
  final String email;

  const UserEntity({
    required this.userid,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [userid, name, email];
}
