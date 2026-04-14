import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/find_car_usecase.dart';
import 'find_car_state.dart';

class FindCarCubit extends Cubit<FindCarState> {
  final FindCarUseCase _findCarUseCase;

  FindCarCubit(this._findCarUseCase) : super(const FindCarInitial());

  Future<void> findMyCar() async {
    emit(const FindCarLoading());

    final result = await _findCarUseCase(const NoParams());

    result.fold(
      (failure) => emit(FindCarError(failure.message)),
      (carLocation) => emit(FindCarLoaded(carLocation)),
    );
  }
}
