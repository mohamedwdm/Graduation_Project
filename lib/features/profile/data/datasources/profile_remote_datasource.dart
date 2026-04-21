import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/profile_model.dart';
import '../models/saved_car_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
  Future<ProfileModel> updateProfileName(String newName);
  Future<List<SavedCarModel>> fetchSavedCars();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileModel> fetchProfile() async {
    // TODO: Replace with _apiClient.get(ApiConstants.profile)
    await Future.delayed(const Duration(milliseconds: 600));
    return const ProfileModel(
      id: 'user_001',
      name: 'Mohamed Ahmed',
      email: 'mohamed.ahmed@go2car.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=user_001',
    );
  }

  @override
  Future<ProfileModel> updateProfileName(String newName) async {
    // TODO: Replace with _apiClient.put(ApiConstants.updateProfile)
    await Future.delayed(const Duration(milliseconds: 800));
    return ProfileModel(
      id: 'user_001',
      name: newName,
      email: 'mohamed.ahmed@go2car.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=user_001',
    );
  }

  @override
  Future<List<SavedCarModel>> fetchSavedCars() async {
    // TODO: Replace with _apiClient.get(ApiConstants.savedCars)
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const SavedCarModel(
        id: 'car_001',
        model: 'Toyota Camry 2024',
        color: 'Silver',
        plateNumber: 'ABC 1234',
      ),
      const SavedCarModel(
        id: 'car_002',
        model: 'Honda Civic 2023',
        color: 'Black',
        plateNumber: 'XYZ 5678',
      ),
    ];
  }
}
