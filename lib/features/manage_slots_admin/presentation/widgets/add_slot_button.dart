import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSlotButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddSlotButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBgColor = isDark ? const Color(0xff10B981) : const Color.fromARGB(255, 73, 212, 119);
    final contentColor = isDark ? Colors.white : const Color(0xff0F172A);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: btnBgColor,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xff10B981) : const Color(0xff13EC5B)).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: -3,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(9999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline, color: contentColor),
                const SizedBox(width: 8),
                Text(
                  "Add Slot",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: contentColor,
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
