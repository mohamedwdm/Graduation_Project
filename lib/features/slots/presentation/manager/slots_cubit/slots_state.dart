import 'package:equatable/equatable.dart';
import '../../../domain/entities/slot_entity.dart';

abstract class SlotsState extends Equatable {
  const SlotsState();

  @override
  List<Object?> get props => [];
}

class SlotsInitial extends SlotsState {
  const SlotsInitial();
}

class SlotsLoading extends SlotsState {
  const SlotsLoading();
}

class SlotsLoaded extends SlotsState {
  final List<SlotEntity> slots;

  const SlotsLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class SlotsError extends SlotsState {
  final String message;

  const SlotsError(this.message);

  @override
  List<Object?> get props => [message];
}
