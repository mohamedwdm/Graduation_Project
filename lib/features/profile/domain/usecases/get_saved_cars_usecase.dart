import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/saved_car_entity.dart';
import '../repositories/profile_repository.dart';

class GetSavedCarsUseCase implements UseCase<List<SavedCarEntity>, NoParams> {
  final ProfileRepository repository;

  GetSavedCarsUseCase(this.repository);

  @override
  FutureEither<List<SavedCarEntity>> call(NoParams params) {
    return repository.getSavedCars();
  }
}
