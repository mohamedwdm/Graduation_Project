import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../manager/profile_cubit/profile_cubit.dart';

class ProfileInfoSection extends StatelessWidget {
  final String name;

  const ProfileInfoSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
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
          child: ListTile(
            onTap: () => _showEditNameDialog(context),
            leading: const Icon(Icons.person_outline, color: Color(0xFF475569)),
            title: Text(
              'Name',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
            subtitle: Text(
              name,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
            ),
            trailing: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF64748B),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ProfileCubit>().updateName(controller.text);
              }
              Navigator.pop(context);
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
