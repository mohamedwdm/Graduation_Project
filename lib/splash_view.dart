import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go2car/core/config/app_router.dart';
import 'package:go2car/core/di/injection_container.dart';
import 'package:go2car/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash screen to show (minimum 2.5 seconds)
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    try {
      final cachedUser = await sl<AuthLocalDataSource>().getCachedUser();
      if (!mounted) return;

      if (cachedUser != null) {
        context.go(AppRouter.homePath, extra: cachedUser);
      } else {
        context.go(AppRouter.loginPath);
      }
    } catch (_) {
      if (mounted) {
        context.go(AppRouter.loginPath);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/car_logo.svg',
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to Go2Car",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Find your spot, hassle-free.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xff525252),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff00A24F)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
