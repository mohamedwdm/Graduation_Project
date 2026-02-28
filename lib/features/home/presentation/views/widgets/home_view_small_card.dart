import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeViewSmallCard extends StatelessWidget {
  const HomeViewSmallCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor, required this.title, required this.subTitle,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
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
              color: iconBackgroundColor,
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
            ),
          ),
          SizedBox(height: 5),
          Text(
            subTitle,
            style: GoogleFonts.spaceGrotesk(
              color: Color(0xff64748B),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
