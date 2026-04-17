import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/slot_entity.dart';
import '../repositories/manage_slots_repository.dart';

class GetManageSlotsUseCase implements UseCase<List<SlotEntity>, int> {
  final ManageSlotsRepository repository;

  GetManageSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SlotEntity>>> call(int floor) async {
    return await repository.getSlots(floor);
  }
}
