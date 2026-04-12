import '../models/slot_model.dart';
import 'slots_repo.dart';

class SlotsRepoImpl implements SlotsRepo {
  // Mock data representing database/backend response
  final Map<int, List<SlotModel>> _mockData = {
    0: [
      const SlotModel(
        slotId: 'Slot A-05',
        locationNote: 'Near Entrance A',
        isAvailable: true,
        hasEvCharging: true,
        isAccessible: true,
        floorIndex: 0,
      ),
      const SlotModel(
        slotId: 'Slot A-06',
        locationNote: 'Near Entrance A',
        isAvailable: false,
        hasEvCharging: false,
        isAccessible: true,
        floorIndex: 0,
      ),
    ],
    1: [
      const SlotModel(
        slotId: 'Slot B-12',
        locationNote: 'Near Elevator',
        isAvailable: true,
        hasEvCharging: true,
        isAccessible: false,
        floorIndex: 1,
      ),
      const SlotModel(
        slotId: 'Slot B-01',
        locationNote: 'West Wing',
        isAvailable: true,
        hasEvCharging: false,
        isAccessible: false,
        floorIndex: 1,
      ),
    ],
    2: [
      const SlotModel(
        slotId: 'Slot C-08',
        locationNote: 'Standard Slot',
        isAvailable: true,
        hasEvCharging: false,
        isAccessible: false,
        floorIndex: 2,
      ),
    ],
    3: [
      const SlotModel(
        slotId: 'Slot D-20',
        locationNote: 'Rooftop Parking',
        isAvailable: true,
        hasEvCharging: false,
        isAccessible: false,
        floorIndex: 3,
      ),
    ],
  };

  @override
  List<SlotModel> getSlotsByFloor({required int floorIndex}) {
    return _mockData[floorIndex] ?? [];
  }

  @override
  Future<List<SlotModel>> fetchSlotsByFloor({required int floorIndex}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return getSlotsByFloor(floorIndex: floorIndex);
  }
}
