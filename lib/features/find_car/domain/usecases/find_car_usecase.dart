import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/car_location_entity.dart';
import '../repositories/find_car_repository.dart';

class FindCarUseCase implements UseCase<CarLocationEntity, NoParams> {
  final FindCarRepository _repository;

  FindCarUseCase(this._repository);

  @override
  FutureEither<CarLocationEntity> call(NoParams params) {
    return _repository.findMyCar();
  }
}
