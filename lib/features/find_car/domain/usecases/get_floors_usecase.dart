import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/find_car_repository.dart';

class FindCarGetFloorsUseCase implements UseCase<List<String>, NoParams> {
  final FindCarRepository _repository;

  FindCarGetFloorsUseCase(this._repository);

  @override
  FutureEither<List<String>> call(NoParams params) {
    return _repository.getFloors();
  }
}
