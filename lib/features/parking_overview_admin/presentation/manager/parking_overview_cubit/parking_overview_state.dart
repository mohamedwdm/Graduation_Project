import 'package:equatable/equatable.dart';
import '../../../domain/entities/parking_overview_entity.dart';

abstract class ParkingOverviewState extends Equatable {
  const ParkingOverviewState();

  @override
  List<Object?> get props => [];
}

class ParkingOverviewInitial extends ParkingOverviewState {}

class ParkingOverviewLoading extends ParkingOverviewState {}

class ParkingOverviewLoaded extends ParkingOverviewState {
  final ParkingOverviewEntity overview;

  const ParkingOverviewLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class ParkingOverviewError extends ParkingOverviewState {
  final String message;

  const ParkingOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class ParkingOverviewForbidden extends ParkingOverviewState {
  const ParkingOverviewForbidden();
}
