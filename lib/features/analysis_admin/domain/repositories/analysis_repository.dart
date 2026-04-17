import 'package:go2car/core/utils/typedefs.dart';
import '../entities/analysis_data_entity.dart';

abstract class AnalysisRepository {
  FutureEither<AnalysisDataEntity> getAnalysisData();
}
