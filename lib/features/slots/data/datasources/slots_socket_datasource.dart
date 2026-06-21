import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/slot_model.dart';

abstract class SlotsSocketDataSource {
  Stream<List<SlotModel>> watchSlotUpdates();
  void connect();
  void disconnect();
}

class SlotsSocketDataSourceImpl implements SlotsSocketDataSource {
  final ApiClient _apiClient;

  SlotsSocketDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  void connect() {
    // No-op since backend doesn't support WebSockets yet, using HTTP polling instead
  }

  @override
  void disconnect() {
    // No-op
  }

  @override
  Stream<List<SlotModel>> watchSlotUpdates() async* {
    while (true) {
      try {
        final response = await _apiClient.get(ApiConstants.slots);
        final List dataList = response.data as List;
        yield dataList.map((e) => SlotModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        // Yield empty or keep polling
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
