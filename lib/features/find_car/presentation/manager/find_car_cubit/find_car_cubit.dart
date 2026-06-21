import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/car_entity.dart';
import '../../../domain/usecases/search_cars_usecase.dart';
import 'find_car_state.dart';

class FindCarCubit extends Cubit<FindCarState> {
  final SearchCarsUseCase _searchCarsUseCase;

  FindCarCubit({
    required SearchCarsUseCase searchCarsUseCase,
  })  : _searchCarsUseCase = searchCarsUseCase,
        super(const FindCarInitial());

  Future<void> searchCars(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const FindCarInitial());
      return;
    }
    emit(const FindCarLoading());
    final result = await _searchCarsUseCase(trimmedQuery);
    result.fold(
      (failure) => emit(FindCarError(failure.message)),
      (backendCars) => emit(FindCarLoaded(backendCars)),
    );
  }
}
