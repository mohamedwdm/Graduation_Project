import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

class ApproveReservationUseCase implements UseCase<ReservationEntity, int> {
  final ReservationRepository repository;

  ApproveReservationUseCase(this.repository);

  @override
  FutureEither<ReservationEntity> call(int params) {
    return repository.approveReservation(params);
  }
}
