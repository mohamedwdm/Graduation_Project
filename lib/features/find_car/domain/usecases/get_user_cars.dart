import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';
import '../repositories/find_car_repository.dart';

class GetUserCarsUseCase implements UseCase<List<CarEntity>, NoParams> {
  final FindCarRepository _repository;

  GetUserCarsUseCase(this._repository);

  @override
  FutureEither<List<CarEntity>> call(NoParams params) {
    return _repository.getUserCars();
  }
}
