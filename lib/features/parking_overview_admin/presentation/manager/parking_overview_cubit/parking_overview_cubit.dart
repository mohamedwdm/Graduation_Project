import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/features/parking_overview_admin/domain/usecases/get_parking_overview_usecase.dart';
import 'parking_overview_state.dart';

class ParkingOverviewCubit extends Cubit<ParkingOverviewState> {
  final GetParkingOverviewUseCase _getParkingOverviewUseCase;

  ParkingOverviewCubit({
    required GetParkingOverviewUseCase getParkingOverviewUseCase,
  })  : _getParkingOverviewUseCase = getParkingOverviewUseCase,
        super(ParkingOverviewInitial());

  Future<void> loadOverview() async {
    emit(ParkingOverviewLoading());

    final result = await _getParkingOverviewUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure is ForbiddenFailure) {
          emit(const ParkingOverviewForbidden());
        } else {
          emit(ParkingOverviewError(failure.message));
        }
      },
      (overview) => emit(ParkingOverviewLoaded(overview)),
    );
  }
}
