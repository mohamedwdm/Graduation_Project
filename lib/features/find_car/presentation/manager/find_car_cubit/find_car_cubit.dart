import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/car_entity.dart';
import '../../../domain/usecases/get_user_cars.dart';
import 'find_car_state.dart';

class FindCarCubit extends Cubit<FindCarState> {
  final GetUserCarsUseCase _getUserCarsUseCase;
  List<CarEntity> _allCars = [];

  FindCarCubit({required GetUserCarsUseCase getUserCarsUseCase})
      : _getUserCarsUseCase = getUserCarsUseCase,
        super(const FindCarInitial());

  Future<void> getUserCars() async {
    emit(const FindCarLoading());
    final result = await _getUserCarsUseCase(const NoParams());
    result.fold(
      (failure) => emit(FindCarError(failure.message)),
      (cars) {
        _allCars = cars;
        emit(FindCarLoaded(cars));
      },
    );
  }

  void searchCars(String query) {
    if (query.isEmpty) {
      emit(FindCarLoaded(_allCars));
      return;
    }
    final lowercaseQuery = query.toLowerCase();
    final filtered = _allCars.where((car) {
      return car.plateNumber.toLowerCase().contains(lowercaseQuery) ||
             car.model.toLowerCase().contains(lowercaseQuery) ||
             car.color.toLowerCase().contains(lowercaseQuery);
    }).toList();
    emit(FindCarLoaded(filtered));
  }
}
