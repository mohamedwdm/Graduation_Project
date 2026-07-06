import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/manage_slots_repository.dart';

class UpdateSlotTypeUseCase implements UseCase<void, UpdateSlotTypeParams> {
  final ManageSlotsRepository repository;

  UpdateSlotTypeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSlotTypeParams params) async {
    return await repository.updateSlotType(
      slotId: params.slotId,
      slotType: params.slotType,
    );
  }
}

class UpdateSlotTypeParams extends Equatable {
  final String slotId;
  final String slotType;

  const UpdateSlotTypeParams({required this.slotId, required this.slotType});

  @override
  List<Object?> get props => [slotId, slotType];
}
