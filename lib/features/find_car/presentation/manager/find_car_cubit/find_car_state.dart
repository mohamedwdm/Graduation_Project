import 'package:equatable/equatable.dart';
import '../../../domain/entities/car_entity.dart';

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
  final List<CarEntity> cars;

  const FindCarLoaded(this.cars);

  @override
  List<Object?> get props => [cars];
}

class FindCarError extends FindCarState {
  final String message;

  const FindCarError(this.message);

  @override
  List<Object?> get props => [message];
}
