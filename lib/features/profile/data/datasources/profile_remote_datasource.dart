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

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileModel> fetchProfile() async {
    if (!_apiClient.hasToken || _apiClient.isGuest) {
      return const ProfileModel(
        id: 'guest_id_from_server',
        name: 'Guest User',
        email: 'guest@go2car.com',
      );
    }
    final response = await _apiClient.get(ApiConstants.profile);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfileName(String newName) async {
    if (!_apiClient.hasToken || _apiClient.isGuest) {
      return const ProfileModel(
        id: 'guest_id_from_server',
        name: 'Guest User',
        email: 'guest@go2car.com',
      );
    }
    final response = await _apiClient.put(
      ApiConstants.updateProfile,
      data: {
        'name': newName,
      },
    );
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<SavedCarModel>> fetchSavedCars() async {
    if (!_apiClient.hasToken || _apiClient.isGuest) {
      return [];
    }
    final response = await _apiClient.get(ApiConstants.savedCars);
    final List dataList = response.data['data'] as List;
    return dataList.map((e) => SavedCarModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<SavedCarModel> addSavedCar(SavedCarModel car) async {
    final response = await _apiClient.post(
      ApiConstants.addVehicle,
      data: car.toJson(),
    );
    final vehicleJson = response.data['data'] as Map<String, dynamic>;
    return SavedCarModel.fromJson(vehicleJson);
  }

  @override
  Future<SavedCarModel> updateSavedCar(SavedCarModel car) async {
    final identifier = car.id.isNotEmpty ? car.id : car.plateNumber;
    final response = await _apiClient.patch(
      '/vehicles/$identifier',
      queryParameters: {
        'color': car.color,
        'vehicle_type': car.model,
      },
    );
    final vehicleJson = response.data['data'] as Map<String, dynamic>;
    return SavedCarModel.fromJson(vehicleJson);
  }

  @override
  Future<void> deleteSavedCar(String id) async {
    await _apiClient.delete('/vehicles/$id');
  }
}
