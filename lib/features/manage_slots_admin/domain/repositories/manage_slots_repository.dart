import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/slot_entity.dart';

abstract class ManageSlotsRepository {
  Future<Either<Failure, List<SlotEntity>>> getSlots(int floor);
  Future<Either<Failure, void>> addSlot({required String slotCode, required int sectionId});
  Future<Either<Failure, List<Map<String, dynamic>>>> getSections();
}
