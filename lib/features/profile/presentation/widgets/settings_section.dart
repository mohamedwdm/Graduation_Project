import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/manager/auth_cubit/auth_cubit.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Preferences & Security',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.27,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildSettingTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Settings',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.security_outlined,
                title: 'Account Security',
                onTap: () {},
              ),
              _buildDivider(),
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
    Color titleColor = const Color(0xFF1E293B),
    Color iconColor = const Color(0xFF475569),
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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 1,
      endIndent: 1,
      color: Color(0xFFE2E8F0),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              sl<AuthCubit>().logout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.spaceGrotesk(color: const Color(0xFFEF4444), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
