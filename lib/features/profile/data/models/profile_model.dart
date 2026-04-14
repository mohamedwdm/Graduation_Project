import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.vehiclePlateNumber,
    super.avatarUrl,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(JsonMap json) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      vehiclePlateNumber: json['vehicle_plate_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'vehicle_plate_number': vehiclePlateNumber,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      vehiclePlateNumber: entity.vehiclePlateNumber,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
