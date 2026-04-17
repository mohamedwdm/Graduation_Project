import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/slot_entity.dart';

abstract class ManageSlotsRepository {
  Future<Either<Failure, List<SlotEntity>>> getSlots(int floor);
}
