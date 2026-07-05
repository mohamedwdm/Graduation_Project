import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';
import '../entities/vehicle_map_entity.dart';

abstract class FindCarRepository {
  FutureEither<List<CarEntity>> searchCars(
    String query, {
    String? floor,
    String? section,
    String? brand,
    String? color,
  });
  FutureEither<List<String>> getFloors();
  FutureEither<List<String>> getSections();
  FutureEither<VehicleMapEntity> getVehicleMap({
    int? slotId,
    String? plate,
    required String floor,
    required String section,
    required String slot,
  });
}
