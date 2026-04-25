import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../repositories/profile_repository.dart';

class DeleteSavedCarUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  DeleteSavedCarUseCase(this.repository);

  @override
  FutureEither<void> call(String params) {
    return repository.deleteSavedCar(params);
  }
}
