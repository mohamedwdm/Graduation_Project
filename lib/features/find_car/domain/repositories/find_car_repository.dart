import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';

abstract class FindCarRepository {
  FutureEither<List<CarEntity>> getUserCars();
}
