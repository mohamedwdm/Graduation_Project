import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/manage_slots_repository.dart';

class UpdateSlotStatusUseCase implements UseCase<void, UpdateSlotStatusParams> {
  final ManageSlotsRepository repository;

  UpdateSlotStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSlotStatusParams params) async {
    return await repository.updateSlotStatus(
      slotId: params.slotId,
      isOccupied: params.isOccupied,
    );
  }
}

class UpdateSlotStatusParams extends Equatable {
  final String slotId;
  final bool isOccupied;

  const UpdateSlotStatusParams({required this.slotId, required this.isOccupied});

  @override
  List<Object?> get props => [slotId, isOccupied];
}
