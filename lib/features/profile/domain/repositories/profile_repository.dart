import '../../../../core/utils/typedefs.dart';
import '../entities/profile_entity.dart';
import '../entities/saved_car_entity.dart';

abstract class ProfileRepository {
  FutureEither<ProfileEntity> getProfile();
  FutureEither<ProfileEntity> updateProfileName(String newName);
  FutureEither<List<SavedCarEntity>> getSavedCars();
  FutureEither<SavedCarEntity> addSavedCar(SavedCarEntity car);
  FutureEither<SavedCarEntity> updateSavedCar(SavedCarEntity car);
  FutureEither<void> deleteSavedCar(String id);
}
