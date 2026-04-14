import '../../../../core/utils/typedefs.dart';
import '../entities/car_location_entity.dart';

abstract class FindCarRepository {
  FutureEither<CarLocationEntity> findMyCar();
}
