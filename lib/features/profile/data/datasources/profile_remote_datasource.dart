import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/profile_model.dart';
import '../models/saved_car_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
  Future<ProfileModel> updateProfileName(String newName);
  Future<List<SavedCarModel>> fetchSavedCars();
  Future<SavedCarModel> addSavedCar(SavedCarModel car);
  Future<SavedCarModel> updateSavedCar(SavedCarModel car);
  Future<void> deleteSavedCar(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  // Mock state
  final List<SavedCarModel> _mockCars = [
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
    // API IMPLEMENTATION (Commented)
    /*
    final response = await _apiClient.get(ApiConstants.savedCars);
    return (response.data as List).map((e) => SavedCarModel.fromJson(e)).toList();
    */

    // MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCars.toList();
  }

  @override
  Future<SavedCarModel> addSavedCar(SavedCarModel car) async {
    // API IMPLEMENTATION (Commented)
    /*
    final response = await _apiClient.post(
      ApiConstants.savedCars,
      data: car.toJson(),
    );
    return SavedCarModel.fromJson(response.data);
    */

    // MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCars.add(car);
    return car;
  }

  @override
  Future<SavedCarModel> updateSavedCar(SavedCarModel car) async {
    // API IMPLEMENTATION (Commented)
    /*
    final response = await _apiClient.put(
      '${ApiConstants.savedCars}/${car.id}',
      data: car.toJson(),
    );
    return SavedCarModel.fromJson(response.data);
    */

    // MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockCars.indexWhere((c) => c.id == car.id);
    if (index != -1) {
      _mockCars[index] = car;
    }
    return car;
  }

  @override
  Future<void> deleteSavedCar(String id) async {
    // API IMPLEMENTATION (Commented)
    /*
    await _apiClient.delete('${ApiConstants.savedCars}/$id');
    */

    // MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCars.removeWhere((c) => c.id == id);
  }
}
