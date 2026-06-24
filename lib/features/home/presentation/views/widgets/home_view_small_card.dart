import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeViewSmallCard extends StatelessWidget {
  const HomeViewSmallCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subTitle, required this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : const Color(0xff64748B);
    final shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.09);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width * 0.43,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? iconBackgroundColor.withOpacity(0.15) : iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),

            Spacer(),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: titleColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subTitle,
              style: GoogleFonts.spaceGrotesk(
                color: subtitleColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
