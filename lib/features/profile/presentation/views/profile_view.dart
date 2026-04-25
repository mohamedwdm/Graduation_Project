import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/profile_cubit/profile_cubit.dart';
import '../manager/profile_cubit/profile_state.dart';
import '../manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/saved_cars_section.dart';
import '../widgets/settings_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (context) => sl<SavedCarsCubit>()..loadSavedCars(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F8F6),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Profile & Settings',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(state.message, style: GoogleFonts.spaceGrotesk()),
                  backgroundColor: const Color(0xFFEF4444),
                ),
              );
            } else if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully',
                      style: GoogleFonts.spaceGrotesk()),
                  backgroundColor: const Color(0xFF13EC5B),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF13EC5B)));
            }

            if (state is ProfileLoaded ||
                state is ProfileUpdateSuccess ||
                state is ProfileUpdating) {
              final dynamic profileState = state;
              final profile = profileState.profile;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeaderWidget(
                        name: profile.name,
                        email: profile.email,
                        avatarUrl: profile.avatarUrl,
                      ),
                      // We can keep ProfileInfoSection as a generic layout or merge it
                      // In the new CSS, there wasn't a separate "Personal Information" section with tiles,
                      // but I'll keep it refactored to match the aesthetic.
                      ProfileInfoSection(name: profile.name),
                      const SavedCarsSection(),
                      const SettingsSection(),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: GoogleFonts.spaceGrotesk()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13EC5B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      child: Text('Retry', style: GoogleFonts.spaceGrotesk()),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
