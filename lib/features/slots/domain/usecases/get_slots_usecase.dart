import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/slot_entity.dart';
import '../repositories/slots_repository.dart';

class GetSlotsUseCase implements UseCase<List<SlotEntity>, NoParams> {
  final SlotsRepository _repository;

  GetSlotsUseCase(this._repository);

  @override
  FutureEither<List<SlotEntity>> call(NoParams params) {
    return _repository.getSlots();
  }
}
