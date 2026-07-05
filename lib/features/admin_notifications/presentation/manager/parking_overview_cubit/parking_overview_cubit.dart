import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/features/admin_notifications/domain/usecases/get_admin_notifications_usecase.dart';
import 'parking_overview_state.dart';

class AdminNotificationsCubit extends Cubit<AdminNotificationsState> {
  final GetParkingOverviewUseCase _getParkingOverviewUseCase;

  AdminNotificationsCubit({
    required GetParkingOverviewUseCase getParkingOverviewUseCase,
  })  : _getParkingOverviewUseCase = getParkingOverviewUseCase,
        super(AdminNotificationsInitial());

  Future<void> loadOverview() async {
    emit(AdminNotificationsLoading());

    final result = await _getParkingOverviewUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure is ForbiddenFailure) {
          emit(const AdminNotificationsForbidden());
        } else {
          emit(AdminNotificationsError(failure.message));
        }
      },
      (overview) => emit(AdminNotificationsLoaded(overview)),
    );
  }
}
