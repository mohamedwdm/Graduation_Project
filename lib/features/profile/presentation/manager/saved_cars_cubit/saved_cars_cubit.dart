import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import '../../../domain/usecases/get_saved_cars_usecase.dart';
import 'saved_cars_state.dart';

class SavedCarsCubit extends Cubit<SavedCarsState> {
  final GetSavedCarsUseCase getSavedCarsUseCase;

  SavedCarsCubit({
    required this.getSavedCarsUseCase,
  }) : super(SavedCarsInitial());

  Future<void> loadSavedCars() async {
    emit(SavedCarsLoading());
    final result = await getSavedCarsUseCase(const NoParams());
    result.fold(
      (failure) => emit(SavedCarsError(failure.message)),
      (cars) {
        if (cars.isEmpty) {
          emit(SavedCarsEmpty());
        } else {
          emit(SavedCarsLoaded(cars));
        }
      },
    );
  }
}
