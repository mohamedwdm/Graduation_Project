import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/views/login_view.dart';

abstract class AppRouter {
  static const String loginPath = '/';
  static const String registerPath = '/register';
  static const String homePath = '/home';

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
    ],
  );
}
