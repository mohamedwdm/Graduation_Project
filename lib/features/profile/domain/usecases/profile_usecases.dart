import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  FutureEither<ProfileEntity> call(NoParams params) {
    return _repository.getProfile();
  }
}

class UpdateProfileUseCase implements UseCase<ProfileEntity, ProfileEntity> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  FutureEither<ProfileEntity> call(ProfileEntity updated) {
    return _repository.updateProfile(updated);
  }
}
