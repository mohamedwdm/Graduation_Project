import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';
import '../repositories/find_car_repository.dart';

class SearchCarsUseCase implements UseCase<List<CarEntity>, String> {
  final FindCarRepository _repository;

  SearchCarsUseCase(this._repository);

  @override
  FutureEither<List<CarEntity>> call(String query) {
    return _repository.searchCars(query);
  }
}
