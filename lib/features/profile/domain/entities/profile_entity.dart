import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  ProfileEntity copyWith({
    String? name,
    String? avatarUrl,
  }) {
    return ProfileEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}
