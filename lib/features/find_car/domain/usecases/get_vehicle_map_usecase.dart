import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/vehicle_map_entity.dart';
import '../repositories/find_car_repository.dart';

class GetVehicleMapUseCase implements UseCase<VehicleMapEntity, String> {
  final FindCarRepository _repository;

  GetVehicleMapUseCase(this._repository);

  @override
  FutureEither<VehicleMapEntity> call(String plate) {
    return _repository.getVehicleMap(plate);
  }
}
