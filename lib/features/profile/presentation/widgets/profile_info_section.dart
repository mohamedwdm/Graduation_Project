import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../manager/profile_cubit/profile_cubit.dart';

class ProfileInfoSection extends StatelessWidget {
  final String name;

  const ProfileInfoSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final tileTextColor = isDark ? Colors.white70 : const Color(0xFF1E293B);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final iconColor = isDark ? Colors.white60 : const Color(0xFF475569);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Personal Information',
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
          child: ListTile(
            onTap: () => _showEditNameDialog(context),
            leading: Icon(Icons.person_outline, color: iconColor),
            title: Text(
              'Name',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: tileTextColor,
              ),
            ),
            subtitle: Text(
              name,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: subtitleColor,
              ),
            ),
            trailing: Icon(
              Icons.edit_outlined,
              color: subtitleColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: name);
    final profileCubit = context.read<ProfileCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Name',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.spaceGrotesk(),
          decoration: InputDecoration(
            labelText: 'New Name',
            labelStyle: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF13EC5B)),
            ),
          ),
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
            onPressed: () {
              if (controller.text.isNotEmpty) {
                profileCubit.updateName(controller.text);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Save',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF13EC5B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
