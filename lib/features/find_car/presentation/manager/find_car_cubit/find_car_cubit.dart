import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_user_cars.dart';
import 'find_car_state.dart';

class FindCarCubit extends Cubit<FindCarState> {
  final GetUserCarsUseCase _getUserCarsUseCase;

  FindCarCubit({required GetUserCarsUseCase getUserCarsUseCase})
      : _getUserCarsUseCase = getUserCarsUseCase,
        super(const FindCarInitial());

  Future<void> getUserCars() async {
    emit(const FindCarLoading());
    final result = await _getUserCarsUseCase(const NoParams());
    result.fold(
      (failure) => emit(FindCarError(failure.message)),
      (cars) => emit(FindCarLoaded(cars)),
    );
  }
}
