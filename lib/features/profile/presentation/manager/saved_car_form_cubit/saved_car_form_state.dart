abstract class SavedCarFormState {}

class SavedCarFormInitial extends SavedCarFormState {}

class SavedCarFormLoading extends SavedCarFormState {}

class SavedCarFormSuccess extends SavedCarFormState {}

class SavedCarFormError extends SavedCarFormState {
  final String message;
  SavedCarFormError(this.message);
}
