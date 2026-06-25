import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';

abstract class FindCarRepository {
  FutureEither<List<CarEntity>> searchCars(String query, {String? floor, String? section});
  FutureEither<List<String>> getFloors();
  FutureEither<List<String>> getSections();
}
