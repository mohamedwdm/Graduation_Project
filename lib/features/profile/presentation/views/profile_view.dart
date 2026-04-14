import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/profile_cubit/profile_cubit.dart';
import 'package:go2car/features/profile/presentation/views/widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const Scaffold(
        body: SafeArea(child: ProfileViewBody()),
        backgroundColor: Color(0xffF6F8F6),
      ),
    );
  }
}
