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
    final response = await _apiClient.get(ApiConstants.profile);
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel model) async {
    final response = await _apiClient.put(
      ApiConstants.updateProfile,
      data: model.toJson(),
    );
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    // Logic for multipart file upload using ApiClient
    final response = await _apiClient.uploadFile(
      ApiConstants.uploadAvatar,
      filePath,
      'avatar',
    );
    return response.data['avatar_url'] as String;
  }
}
