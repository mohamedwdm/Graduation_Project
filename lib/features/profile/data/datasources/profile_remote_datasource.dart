import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
  Future<ProfileModel> updateProfile(ProfileModel model);
  Future<String> uploadAvatar(String filePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileModel> fetchProfile() async {
    // Simulated remote call
    await Future.delayed(const Duration(milliseconds: 700));
    
    return ProfileModel.fromJson({
      'id': 'user_123',
      'name': 'Ali Mohamed',
      'email': 'ali.mohamed@example.com',
      'phone_number': '+201234567890',
      'vehicle_plate_number': 'ABC 123',
      'avatar_url': 'https://i.pravatar.cc/150?u=user_123',
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    });
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel model) async {
    // Simulated remote call
    await Future.delayed(const Duration(seconds: 1));
    return model;
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    // Simulated remote call
    await Future.delayed(const Duration(seconds: 2));
    return 'https://i.pravatar.cc/150?u=user_123_new';
  }
}
