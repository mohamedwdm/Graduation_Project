import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_dashboard_summary_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;

  HomeCubit(this._getDashboardSummaryUseCase) : super(const HomeInitial());

  Future<void> loadDashboard() async {
    emit(const HomeLoading());

    final result = await _getDashboardSummaryUseCase(const NoParams());

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (summary) => emit(HomeLoaded(summary)),
    );
  }
}
