import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

class CreateReservationUseCase implements UseCase<ReservationEntity, CreateReservationParams> {
  final ReservationRepository repository;

  CreateReservationUseCase(this.repository);

  @override
  FutureEither<ReservationEntity> call(CreateReservationParams params) {
    return repository.createReservation(
      slotCode: params.slotCode,
      plateNumber: params.plateNumber,
      startTime: params.startTime,
      endTime: params.endTime,
    );
  }
}

class CreateReservationParams extends Equatable {
  final String slotCode;
  final String plateNumber;
  final DateTime startTime;
  final DateTime endTime;

  const CreateReservationParams({
    required this.slotCode,
    required this.plateNumber,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [slotCode, plateNumber, startTime, endTime];
}
