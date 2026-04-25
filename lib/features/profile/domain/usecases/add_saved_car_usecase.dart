import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/saved_car_entity.dart';
import '../repositories/profile_repository.dart';

class AddSavedCarUseCase implements UseCase<SavedCarEntity, SavedCarEntity> {
  final ProfileRepository repository;

  AddSavedCarUseCase(this.repository);

  @override
  FutureEither<SavedCarEntity> call(SavedCarEntity params) {
    return repository.addSavedCar(params);
  }
}
