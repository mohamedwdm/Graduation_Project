import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/analysis_data_entity.dart';
import '../repositories/analysis_repository.dart';

class GetAnalysisDataUseCase implements UseCase<AnalysisDataEntity, NoParams> {
  final AnalysisRepository _repository;

  GetAnalysisDataUseCase(this._repository);

  @override
  FutureEither<AnalysisDataEntity> call(NoParams params) {
    return _repository.getAnalysisData();
  }
}
