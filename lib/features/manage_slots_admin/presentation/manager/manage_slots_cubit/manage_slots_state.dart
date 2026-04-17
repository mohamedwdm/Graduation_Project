import 'package:equatable/equatable.dart';
import '../../../domain/entities/slot_entity.dart';

abstract class ManageSlotsState extends Equatable {
  const ManageSlotsState();

  @override
  List<Object?> get props => [];
}

class ManageSlotsInitial extends ManageSlotsState {}

class ManageSlotsLoading extends ManageSlotsState {}

class ManageSlotsLoaded extends ManageSlotsState {
  final List<SlotEntity> slots;
  final int floor;

  const ManageSlotsLoaded({required this.slots, required this.floor});

  @override
  List<Object?> get props => [slots, floor];
}

class ManageSlotsError extends ManageSlotsState {
  final String message;

  const ManageSlotsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ManageSlotsForbidden extends ManageSlotsState {
  final String message;

  const ManageSlotsForbidden({required this.message});

  @override
  List<Object?> get props => [message];
}
