import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/manage_slots_repository.dart';

class AddSlotUseCase implements UseCase<void, AddSlotParams> {
  final ManageSlotsRepository repository;

  AddSlotUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddSlotParams params) async {
    return await repository.addSlot(
      slotCode: params.slotCode,
      sectionId: params.sectionId,
    );
  }
}

class AddSlotParams extends Equatable {
  final String slotCode;
  final int sectionId;

  const AddSlotParams({required this.slotCode, required this.sectionId});

  @override
  List<Object?> get props => [slotCode, sectionId];
}
