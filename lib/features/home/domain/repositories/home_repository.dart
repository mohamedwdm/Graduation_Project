import '../../../../core/utils/typedefs.dart';
import '../entities/dashboard_summary_entity.dart';

abstract class HomeRepository {
  FutureEither<DashboardSummaryEntity> getDashboardSummary();
}
