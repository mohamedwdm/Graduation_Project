import '../models/slot_model.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/slot_entity.dart';

abstract class ManageSlotsDataSource {
  Future<List<SlotModel>> getSlots(int floor);
}

class ManageSlotsRemoteDataSourceImpl implements ManageSlotsDataSource {
  final ApiClient apiClient;

  ManageSlotsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SlotModel>> getSlots(int floor) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await apiClient.get('/admin/slots?floor=$floor');
    // return (response.data as List).map((e) => SlotModel.fromJson(e)).toList();
    throw UnimplementedError('Remote data source not implemented');
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
}
