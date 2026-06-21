import 'package:equatable/equatable.dart';

abstract class SavedCarFormState extends Equatable {
  const SavedCarFormState();

  @override
  List<Object?> get props => [];
}

class SavedCarFormInitial extends SavedCarFormState {}

class SavedCarFormLoading extends SavedCarFormState {}

class SavedCarFormSuccess extends SavedCarFormState {}

class SavedCarFormError extends SavedCarFormState {
  final String message;

  const SavedCarFormError(this.message);

  @override
  List<Object?> get props => [message];
}
