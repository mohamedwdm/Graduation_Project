import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/parking_overview_entity.dart';
import '../repositories/parking_overview_repository.dart';

class GetParkingOverviewUseCase implements UseCase<ParkingOverviewEntity, NoParams> {
  final ParkingOverviewRepository _repository;

  GetParkingOverviewUseCase(this._repository);

  @override
  FutureEither<ParkingOverviewEntity> call(NoParams params) async {
    return await _repository.getParkingOverview();
  }
}
