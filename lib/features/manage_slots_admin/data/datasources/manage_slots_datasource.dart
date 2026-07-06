import '../models/slot_model.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/slot_entity.dart';

abstract class ManageSlotsDataSource {
  Future<List<SlotModel>> getSlots(int floor);
  Future<void> addSlot({required String slotCode, required int sectionId});
  Future<List<Map<String, dynamic>>> getSections();
  Future<void> updateSlotType({required String slotId, required String slotType});
}

class ManageSlotsRemoteDataSourceImpl implements ManageSlotsDataSource {
  final ApiClient apiClient;

  ManageSlotsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SlotModel>> getSlots(int floor) async {
    final response = await apiClient.get('/slots/all');
    final List dataList = response.data as List;
    final List<SlotModel> allSlots = dataList.map((e) => SlotModel.fromJson(e as Map<String, dynamic>)).toList();
    return allSlots.where((slot) => slot.floor == floor).toList();
  }

  @override
  Future<void> addSlot({required String slotCode, required int sectionId}) async {
    await apiClient.post('/slots/', data: {
      'slot_code': slotCode,
      'section_id': sectionId,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getSections() async {
    final response = await apiClient.get('/sections/all');
    final List dataList = response.data as List;
    return dataList.map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  Future<void> updateSlotType({required String slotId, required String slotType}) async {
    await apiClient.patch('/slots/$slotId', data: {
      'slot_type': slotType,
    });
  }
}

class ManageSlotsMockDataSourceImpl implements ManageSlotsDataSource {
  @override
  Future<List<SlotModel>> getSlots(int floor) async {
    // Simulate network latency as requested
    await Future.delayed(const Duration(milliseconds: 800));

    if (floor == 1) {
      return [
        const SlotModel(
          id: '1',
          name: 'A-01',
          floor: 1,
          status: SlotStatus.available,
          location: 'Near Entrance A',
          isEV: true,
          isAccessible: false,
        ),
        const SlotModel(
          id: '2',
          name: 'A-02',
          floor: 1,
          status: SlotStatus.occupied,
          location: 'Main Row',
          isEV: false,
          isAccessible: true,
        ),
        const SlotModel(
          id: '3',
          name: 'A-03',
          floor: 1,
          status: SlotStatus.maintenance,
          location: 'Near Elevator',
          isEV: true,
          isAccessible: true,
        ),
        const SlotModel(
          id: '4',
          name: 'A-04',
          floor: 1,
          status: SlotStatus.available,
          location: 'South Side',
          isEV: false,
          isAccessible: false,
        ),
      ];
    } else if (floor == 2) {
      return [
        const SlotModel(
          id: '5',
          name: 'B-11',
          floor: 2,
          status: SlotStatus.available,
          location: 'East Wing',
          isEV: false,
          isAccessible: false,
        ),
        const SlotModel(
          id: '6',
          name: 'B-12',
          floor: 2,
          status: SlotStatus.maintenance,
          location: 'Near Elevator',
          isEV: true,
          isAccessible: false,
        ),
      ];
    } else {
      return [
        const SlotModel(
          id: '7',
          name: 'C-08',
          floor: 3,
          status: SlotStatus.occupied,
          location: 'Standard Slot',
          isEV: false,
          isAccessible: false,
        ),
      ];
    }
  }

  @override
  Future<void> addSlot({required String slotCode, required int sectionId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Map<String, dynamic>>> getSections() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 1,
        'section_code': 'A',
        'section_name': 'Section A',
        'floor': {
          'id': 1,
          'floor_code': '1',
          'floor_name': 'Floor 1',
        }
      },
      {
        'id': 2,
        'section_code': 'B',
        'section_name': 'Section B',
        'floor': {
          'id': 2,
          'floor_code': '2',
          'floor_name': 'Floor 2',
        }
      },
      {
        'id': 3,
        'section_code': 'C',
        'section_name': 'Section C',
        'floor': {
          'id': 3,
          'floor_code': '3',
          'floor_name': 'Floor 3',
        }
      },
    ];
  }

  @override
  Future<void> updateSlotType({required String slotId, required String slotType}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
