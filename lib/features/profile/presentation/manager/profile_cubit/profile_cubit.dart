import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? vehiclePlateNumber,
    String? avatarUrl,
  }) async {
    if (state is! ProfileLoaded) return;

    final currentProfile = (state as ProfileLoaded).profile;
    final updatedProfile = currentProfile.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      vehiclePlateNumber: vehiclePlateNumber,
      avatarUrl: avatarUrl,
    );

    emit(const ProfileUpdating());

    final result = await _updateProfileUseCase(updatedProfile);

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (updated) => emit(ProfileLoaded(updated)),
    );
  }
}
