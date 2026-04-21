import 'package:equatable/equatable.dart';
import '../../../domain/entities/saved_car_entity.dart';

abstract class SavedCarsState extends Equatable {
  const SavedCarsState();

  @override
  List<Object?> get props => [];
}

class SavedCarsInitial extends SavedCarsState {}

class SavedCarsLoading extends SavedCarsState {}

class SavedCarsLoaded extends SavedCarsState {
  final List<SavedCarEntity> cars;
  const SavedCarsLoaded(this.cars);

  @override
  List<Object?> get props => [cars];
}

class SavedCarsEmpty extends SavedCarsState {}

class SavedCarsError extends SavedCarsState {
  final String message;
  const SavedCarsError(this.message);

  @override
  List<Object?> get props => [message];
}
