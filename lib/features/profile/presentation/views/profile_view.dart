import 'package:flutter/material.dart';
import 'package:go2car/features/profile/presentation/views/widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ProfileViewBody()),
      backgroundColor: Color(0xffF6F8F6),
    );
  }
}
