import 'package:flutter/material.dart';
import 'package:go2car/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../../core/di/injection_container.dart';

class SlotsHeaderSection extends StatefulWidget {
  const SlotsHeaderSection({super.key});

  @override
  State<SlotsHeaderSection> createState() => _SlotsHeaderSectionState();
}

class _SlotsHeaderSectionState extends State<SlotsHeaderSection> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await sl<AuthLocalDataSource>().getCachedUser();
      if (mounted) {
        setState(() {
          _userName = user?.name ?? '';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = _userName.toLowerCase() == 'guest' || _userName.isEmpty;
    final welcomeStyle = TextStyle(
      fontFamily: 'Space Grotesk',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: const Color(0xFF64748B),
    );
    final nameStyle = TextStyle(
      fontFamily: 'Space Grotesk',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      letterSpacing: -0.3,
      color: const Color(0xFF0F172A),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back!', style: welcomeStyle),
              const SizedBox(height: 4),
              Text(isGuest ? 'User' : _userName, style: nameStyle),
            ],
          ),
        ],
      ),
    );
  }
}
