import 'package:equatable/equatable.dart';
import '../../../domain/entities/car_location_entity.dart';

abstract class FindCarState extends Equatable {
  const FindCarState();

  @override
  List<Object?> get props => [];
}

class FindCarInitial extends FindCarState {
  const FindCarInitial();
}

class FindCarLoading extends FindCarState {
  const FindCarLoading();
}

class FindCarLoaded extends FindCarState {
  final CarLocationEntity carLocation;

  const FindCarLoaded(this.carLocation);

  @override
  List<Object?> get props => [carLocation];
}

class FindCarError extends FindCarState {
  final String message;

  const FindCarError(this.message);

  @override
  List<Object?> get props => [message];
}
