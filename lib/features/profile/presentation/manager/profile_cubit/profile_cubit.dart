import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_name_usecase.dart';
import '../../../domain/entities/profile_entity.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileNameUseCase updateProfileNameUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileNameUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase(const NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateName(String newName) async {
    final currentState = state;
    ProfileEntity? currentProfile;

    if (currentState is ProfileLoaded) {
      currentProfile = currentState.profile;
    } else if (currentState is ProfileUpdateSuccess) {
      currentProfile = currentState.profile;
    } else if (currentState is ProfileUpdating) {
      currentProfile = currentState.profile;
    }

    if (currentProfile == null) return;

    emit(ProfileUpdating(currentProfile));

    final result = await updateProfileNameUseCase(newName);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (updatedProfile) => emit(ProfileUpdateSuccess(updatedProfile)),
    );
  }
}
