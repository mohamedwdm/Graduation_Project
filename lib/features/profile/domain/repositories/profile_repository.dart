import '../../../../core/utils/typedefs.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  FutureEither<ProfileEntity> getProfile();
  FutureEither<ProfileEntity> updateProfile(ProfileEntity updated);
  FutureEither<String> uploadAvatar(String filePath);
}
