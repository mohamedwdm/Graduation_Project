import '../models/slot_model.dart';

abstract class SlotsRepo {
  /// Fetches the slots for a given floor index asynchronously
  Future<List<SlotModel>> fetchSlotsByFloor({required int floorIndex});
  
  /// Fetches the slots synchronously (useful for mocked local storage)
  List<SlotModel> getSlotsByFloor({required int floorIndex});
}
