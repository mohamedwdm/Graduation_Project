import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../manager/theme_cubit/theme_cubit.dart';

class SettingsSection extends StatelessWidget {
  final bool isAdmin;
  final bool isGuest;
  const SettingsSection({super.key, this.isAdmin = false, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final tileTextColor = isDark ? Colors.white70 : const Color(0xFF1E293B);
    final tileIconColor = isDark ? Colors.white60 : const Color(0xFF475569);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            isGuest ? 'Preferences' : 'Preferences & Security',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.27,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: isGuest
                ? [
                    _buildSettingTile(
                      icon: Icons.palette_outlined,
                      title: 'App Appearance',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () => _showThemeSelectionDialog(context),
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.login_outlined,
                      title: 'Sign In / Register',
                      titleColor: const Color(0xff00A24F),
                      iconColor: const Color(0xff00A24F),
                      showChevron: false,
                      onTap: () async {
                        await sl<AuthCubit>().logout();
                        if (context.mounted) {
                          context.go(AppRouter.loginPath);
                        }
                      },
                    ),
                  ]
                : [
                    _buildSettingTile(
                      icon: Icons.notifications_none_outlined,
                      title: 'Notifications',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () {},
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Payment Methods',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () {},
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.palette_outlined,
                      title: 'App Appearance',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () => _showThemeSelectionDialog(context),
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: isAdmin ? Icons.book_online_outlined : Icons.receipt_long_outlined,
                      title: isAdmin ? 'Manage Bookings' : 'Booking History',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () => context.push(isAdmin ? AppRouter.adminReservationsPath : AppRouter.bookingHistoryPath),
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.security_outlined,
                      title: 'Account Security',
                      titleColor: tileTextColor,
                      iconColor: tileIconColor,
                      onTap: () => context.push(AppRouter.changePasswordPath),
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      titleColor: const Color(0xFFEF4444),
                      iconColor: const Color(0xFFEF4444),
                      showChevron: false,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }


  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color titleColor,
    required Color iconColor,
    bool showChevron = true,
  }) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 20,
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        title,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20)
          : null,
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 1,
      endIndent: 1,
      color: color,
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final themeCubit = context.read<ThemeCubit>();
        return BlocBuilder<ThemeCubit, ThemeMode>(
          bloc: themeCubit,
          builder: (context, currentMode) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'App Appearance',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'System Default',
                      style: GoogleFonts.spaceGrotesk(),
                    ),
                    value: ThemeMode.system,
                    groupValue: currentMode,
                    activeColor: const Color(0xFF00A24F),
                    onChanged: (mode) {
                      if (mode != null) themeCubit.setThemeMode(mode);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'Light Mode',
                      style: GoogleFonts.spaceGrotesk(),
                    ),
                    value: ThemeMode.light,
                    groupValue: currentMode,
                    activeColor: const Color(0xFF00A24F),
                    onChanged: (mode) {
                      if (mode != null) themeCubit.setThemeMode(mode);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'Dark Mode',
                      style: GoogleFonts.spaceGrotesk(),
                    ),
                    value: ThemeMode.dark,
                    groupValue: currentMode,
                    activeColor: const Color(0xFF00A24F),
                    onChanged: (mode) {
                      if (mode != null) themeCubit.setThemeMode(mode);
                      Navigator.pop(dialogContext);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.spaceGrotesk(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await sl<AuthCubit>().logout();
              if (context.mounted) {
                context.go(AppRouter.loginPath);
              }
            },
            child: Text(
              'Logout',
              style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFFEF4444), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
