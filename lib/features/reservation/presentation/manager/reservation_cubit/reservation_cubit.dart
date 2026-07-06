import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/cancel_reservation_usecase.dart';
import '../../../domain/usecases/create_reservation_usecase.dart';
import '../../../domain/usecases/get_my_reservations_usecase.dart';
import '../../../domain/usecases/get_all_reservations_usecase.dart';
import '../../../domain/usecases/approve_reservation_usecase.dart';
import '../../../domain/usecases/reject_reservation_usecase.dart';
import 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final CreateReservationUseCase createReservationUseCase;
  final GetMyReservationsUseCase getMyReservationsUseCase;
  final CancelReservationUseCase cancelReservationUseCase;
  final GetAllReservationsUseCase getAllReservationsUseCase;
  final ApproveReservationUseCase approveReservationUseCase;
  final RejectReservationUseCase rejectReservationUseCase;

  ReservationCubit({
    required this.createReservationUseCase,
    required this.getMyReservationsUseCase,
    required this.cancelReservationUseCase,
    required this.getAllReservationsUseCase,
    required this.approveReservationUseCase,
    required this.rejectReservationUseCase,
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

  Future<void> getAllReservations() async {
    emit(AllReservationsLoading());
    final result = await getAllReservationsUseCase(const NoParams());
    result.fold(
      (failure) => emit(AllReservationsError(failure.message)),
      (reservations) => emit(AllReservationsLoaded(reservations)),
    );
  }

  Future<void> approveReservation(int reservationId) async {
    emit(ApproveReservationLoading());
    final result = await approveReservationUseCase(reservationId);
    result.fold(
      (failure) => emit(ApproveReservationError(failure.message)),
      (reservation) => emit(ApproveReservationSuccess(reservation)),
    );
  }

  Future<void> rejectReservation(int reservationId) async {
    emit(RejectReservationLoading());
    final result = await rejectReservationUseCase(reservationId);
    result.fold(
      (failure) => emit(RejectReservationError(failure.message)),
      (reservation) => emit(RejectReservationSuccess(reservation)),
    );
  }
}

