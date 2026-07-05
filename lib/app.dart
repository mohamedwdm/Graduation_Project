import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_theme.dart';
import 'core/config/app_router.dart';
import 'core/di/injection_container.dart';
import 'features/find_car/presentation/manager/find_car_cubit/find_car_cubit.dart';
import 'features/profile/presentation/manager/saved_cars_cubit/saved_cars_cubit.dart';
import 'features/profile/presentation/manager/theme_cubit/theme_cubit.dart';
import 'features/auth/presentation/manager/auth_cubit/auth_cubit.dart';

class Go2CarApp extends StatelessWidget {
  const Go2CarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<FindCarCubit>()),
        BlocProvider(create: (context) => sl<SavedCarsCubit>()..loadSavedCars()),
        BlocProvider(create: (context) => sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Go2Car',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
