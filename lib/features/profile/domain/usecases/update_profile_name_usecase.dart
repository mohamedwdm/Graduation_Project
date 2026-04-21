import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileNameUseCase implements UseCase<ProfileEntity, String> {
  final ProfileRepository repository;

  UpdateProfileNameUseCase(this.repository);

  @override
  FutureEither<ProfileEntity> call(String newName) {
    return repository.updateProfileName(newName);
  }
}
