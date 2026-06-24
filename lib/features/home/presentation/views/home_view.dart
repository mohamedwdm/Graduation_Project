import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/home_cubit/home_cubit.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadDashboard(),
      child: Scaffold(
        body: const SafeArea(child: HomeViewBody()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
