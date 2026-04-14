import 'package:flutter/material.dart';
import 'core/config/app_theme.dart';
import 'core/config/app_router.dart';

class Go2CarApp extends StatelessWidget {
  const Go2CarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Go2Car',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
