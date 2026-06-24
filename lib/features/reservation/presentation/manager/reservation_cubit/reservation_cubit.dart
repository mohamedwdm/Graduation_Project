import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/cancel_reservation_usecase.dart';
import '../../../domain/usecases/create_reservation_usecase.dart';
import '../../../domain/usecases/get_my_reservations_usecase.dart';
import 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final CreateReservationUseCase createReservationUseCase;
  final GetMyReservationsUseCase getMyReservationsUseCase;
  final CancelReservationUseCase cancelReservationUseCase;

  ReservationCubit({
    required this.createReservationUseCase,
    required this.getMyReservationsUseCase,
    required this.cancelReservationUseCase,
  }) : super(ReservationInitial());

  Future<void> reserveSlot({
    required String slotCode,
    required String plateNumber,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    emit(ReservationLoading());
    final result = await createReservationUseCase(
      CreateReservationParams(
        slotCode: slotCode,
        plateNumber: plateNumber,
        startTime: startTime,
        endTime: endTime,
      ),
    );
    result.fold(
      (failure) => emit(ReservationError(failure.message)),
      (reservation) => emit(ReservationSuccess(reservation)),
    );
  }

  Future<void> getMyReservations() async {
    emit(MyReservationsLoading());
    final result = await getMyReservationsUseCase(const NoParams());
    result.fold(
      (failure) => emit(MyReservationsError(failure.message)),
      (reservations) => emit(MyReservationsLoaded(reservations)),
    );
  }

  Future<void> cancelReservation(int reservationId) async {
    emit(CancelReservationLoading());
    final result = await cancelReservationUseCase(reservationId);
    result.fold(
      (failure) => emit(CancelReservationError(failure.message)),
      (reservation) => emit(CancelReservationSuccess(reservation)),
    );
  }
}
