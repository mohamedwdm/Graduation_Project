import 'package:equatable/equatable.dart';
import '../../../domain/entities/reservation_entity.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final ReservationEntity reservation;
  const ReservationSuccess(this.reservation);

  @override
  List<Object?> get props => [reservation];
}

class ReservationError extends ReservationState {
  final String message;
  const ReservationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyReservationsLoading extends ReservationState {}

class MyReservationsLoaded extends ReservationState {
  final List<ReservationEntity> reservations;
  const MyReservationsLoaded(this.reservations);

  @override
  List<Object?> get props => [reservations];
}

class MyReservationsError extends ReservationState {
  final String message;
  const MyReservationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CancelReservationLoading extends ReservationState {}

class CancelReservationSuccess extends ReservationState {
  final ReservationEntity reservation;
  const CancelReservationSuccess(this.reservation);

  @override
  List<Object?> get props => [reservation];
}

class CancelReservationError extends ReservationState {
  final String message;
  const CancelReservationError(this.message);

  @override
  List<Object?> get props => [message];
}
