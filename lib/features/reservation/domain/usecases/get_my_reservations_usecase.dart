import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

class GetMyReservationsUseCase implements UseCase<List<ReservationEntity>, NoParams> {
  final ReservationRepository repository;

  GetMyReservationsUseCase(this.repository);

  @override
  FutureEither<List<ReservationEntity>> call(NoParams params) {
    return repository.getMyReservations();
  }
}
