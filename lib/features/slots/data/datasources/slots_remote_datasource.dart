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
    // Simulated remote call
    await Future.delayed(const Duration(milliseconds: 600));
    
    final List<Map<String, dynamic>> mockSlots = List.generate(24, (index) {
      final floor = (index / 10).floor() + 1;
      final section = String.fromCharCode(65 + (index % 3)); // A, B, C
      return {
        'id': 'slot_$index',
        'label': '$section-${index + 1}',
        'is_occupied': index % 3 == 0,
        'floor': floor,
        'section': 'Section $section',
        'has_ev_charging': index % 5 == 0,
        'is_accessible': index % 8 == 0,
        'last_updated': DateTime.now().subtract(Duration(minutes: index * 5)).toIso8601String(),
      };
    });
    
    return mockSlots.map((json) => SlotModel.fromJson(json)).toList();
  }

  @override
  Future<SlotModel> fetchSlotById(String id) async {
    // Simulated remote call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return SlotModel.fromJson({
      'id': id,
      'label': 'A-1',
      'is_occupied': false,
      'floor': 1,
      'section': 'Section A',
      'has_ev_charging': true,
      'is_accessible': true,
      'last_updated': DateTime.now().toIso8601String(),
    });
  }
}
