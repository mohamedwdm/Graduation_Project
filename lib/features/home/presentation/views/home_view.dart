import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/home_cubit/home_cubit.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  final bool isGuest;

  const HomeView({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadDashboard(),
      child: Scaffold(
        body: SafeArea(child: HomeViewBody(isGuest: isGuest)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
