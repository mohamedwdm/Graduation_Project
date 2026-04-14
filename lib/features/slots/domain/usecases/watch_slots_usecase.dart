import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/slot_entity.dart';
import '../repositories/slots_repository.dart';

class WatchSlotsUseCase implements StreamUseCase<List<SlotEntity>, NoParams> {
  final SlotsRepository _repository;

  WatchSlotsUseCase(this._repository);

  @override
  StreamEither<List<SlotEntity>> call(NoParams params) {
    return _repository.watchSlots();
  }
}
