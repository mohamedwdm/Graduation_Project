import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/di/injection_container.dart';
import 'package:go2car/features/parking_overview_admin/presentation/manager/parking_overview_cubit/parking_overview_cubit.dart';
import 'package:go2car/features/parking_overview_admin/presentation/views/parking_overview_view.dart';
import '../../features/auth/presentation/views/login_view.dart';

abstract class AppRouter {
  static const String loginPath = '/';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String adminParkingOverviewPath = '/admin/parking-overview';

  static final router = GoRouter(
    initialLocation: loginPath,
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Register View Placeholder'))),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home View Placeholder'))),
      ),
      GoRoute(
        path: adminParkingOverviewPath,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ParkingOverviewCubit>(),
          child: const ParkingOverviewView(),
        ),
      ),
    ],
  );
}
