import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/slot_model.dart';

abstract class SlotsRemoteDataSource {
  Future<List<SlotModel>> fetchAllSlots();
  Future<SlotModel> fetchSlotById(String id);
}

class SlotsRemoteDataSourceImpl implements SlotsRemoteDataSource {
  final ApiClient _apiClient;

  SlotsRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<SlotModel>> fetchAllSlots() async {
    final response = await _apiClient.get(ApiConstants.slots);
    
    // Based on standard FastAPI list response
    final List<dynamic> data = response.data['slots'] ?? response.data;
    return data.map((json) => SlotModel.fromJson(json)).toList();
  }

  @override
  Future<SlotModel> fetchSlotById(String id) async {
    final response = await _apiClient.get('${ApiConstants.slots}/$id');
    return SlotModel.fromJson(response.data);
  }
}
