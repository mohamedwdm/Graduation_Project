import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/features/auth/data/repos/user_repo_impl.dart';
import 'package:go2car/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:go2car/features/auth/presentation/views/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(UserRepoImpl()),
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const SafeArea(child: LoginViewBody()),
      ),
    );
  }
}
