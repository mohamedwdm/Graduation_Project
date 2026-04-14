import '../../../../core/utils/typedefs.dart';
import '../entities/slot_entity.dart';

abstract class SlotsRepository {
  FutureEither<List<SlotEntity>> getSlots();
  FutureEither<SlotEntity> getSlotById(String id);
  StreamEither<List<SlotEntity>> watchSlots();
}
