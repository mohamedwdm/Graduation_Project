import '../../../../core/utils/typedefs.dart';
import '../entities/reservation_entity.dart';

abstract class ReservationRepository {
  FutureEither<ReservationEntity> createReservation({
    required String slotCode,
    required String plateNumber,
    required DateTime startTime,
    required DateTime endTime,
  });

  FutureEither<List<ReservationEntity>> getMyReservations();

  FutureEither<ReservationEntity> cancelReservation(int reservationId);
}
