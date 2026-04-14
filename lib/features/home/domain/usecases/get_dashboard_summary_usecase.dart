import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/dashboard_summary_entity.dart';
import '../repositories/home_repository.dart';

class GetDashboardSummaryUseCase implements UseCase<DashboardSummaryEntity, NoParams> {
  final HomeRepository _repository;

  GetDashboardSummaryUseCase(this._repository);

  @override
  FutureEither<DashboardSummaryEntity> call(NoParams params) {
    return _repository.getDashboardSummary();
  }
}
