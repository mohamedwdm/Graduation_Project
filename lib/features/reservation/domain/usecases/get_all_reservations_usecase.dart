import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

class GetAllReservationsUseCase implements UseCase<List<ReservationEntity>, NoParams> {
  final ReservationRepository repository;

  GetAllReservationsUseCase(this.repository);

  @override
  FutureEither<List<ReservationEntity>> call(NoParams params) {
    return repository.getAllReservations();
  }
}
