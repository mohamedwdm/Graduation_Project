import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/saved_car_entity.dart';
import '../../../domain/usecases/add_saved_car_usecase.dart';
import '../../../domain/usecases/update_saved_car_usecase.dart';
import '../../../domain/usecases/delete_saved_car_usecase.dart';
import 'saved_car_form_state.dart';

class SavedCarFormCubit extends Cubit<SavedCarFormState> {
  final AddSavedCarUseCase addSavedCarUseCase;
  final UpdateSavedCarUseCase updateSavedCarUseCase;
  final DeleteSavedCarUseCase deleteSavedCarUseCase;

  SavedCarFormCubit({
    required this.addSavedCarUseCase,
    required this.updateSavedCarUseCase,
    required this.deleteSavedCarUseCase,
  }) : super(SavedCarFormInitial());

  Future<void> addCar(SavedCarEntity car) async {
    emit(SavedCarFormLoading());
    final result = await addSavedCarUseCase(car);
    result.fold(
      (failure) => emit(SavedCarFormError(failure.message)),
      (_) => emit(SavedCarFormSuccess()),
    );
  }

  Future<void> updateCar(SavedCarEntity car) async {
    emit(SavedCarFormLoading());
    final result = await updateSavedCarUseCase(car);
    result.fold(
      (failure) => emit(SavedCarFormError(failure.message)),
      (_) => emit(SavedCarFormSuccess()),
    );
  }

  Future<void> deleteCar(String id) async {
    emit(SavedCarFormLoading());
    final result = await deleteSavedCarUseCase(id);
    result.fold(
      (failure) => emit(SavedCarFormError(failure.message)),
      (_) => emit(SavedCarFormSuccess()),
    );
  }
}
