import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/vehicle_map_entity.dart';
import '../repositories/find_car_repository.dart';

class GetVehicleMapParams {
  final int? slotId;
  final String? plate;
  final String floor;
  final String section;
  final String slot;

  const GetVehicleMapParams({
    this.slotId,
    this.plate,
    required this.floor,
    required this.section,
    required this.slot,
  });
}

class GetVehicleMapUseCase implements UseCase<VehicleMapEntity, GetVehicleMapParams> {
  final FindCarRepository _repository;

  GetVehicleMapUseCase(this._repository);

  @override
  FutureEither<VehicleMapEntity> call(GetVehicleMapParams params) {
    return _repository.getVehicleMap(
      slotId: params.slotId,
      plate: params.plate,
      floor: params.floor,
      section: params.section,
      slot: params.slot,
    );
  }
}
