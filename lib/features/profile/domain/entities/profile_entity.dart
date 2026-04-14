import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? vehiclePlateNumber;
  final String? avatarUrl;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.vehiclePlateNumber,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        vehiclePlateNumber,
        avatarUrl,
        createdAt,
      ];

  ProfileEntity copyWith({
    String? name,
    String? phoneNumber,
    String? vehiclePlateNumber,
    String? avatarUrl,
  }) {
    return ProfileEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
