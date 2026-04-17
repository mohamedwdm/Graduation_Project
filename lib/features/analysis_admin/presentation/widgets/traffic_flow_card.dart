import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrafficFlowCard extends StatelessWidget {
  final String title;
  final String count;
  final String trend;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const TrafficFlowCard({
    super.key,
    required this.title,
    required this.count,
    required this.trend,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xff64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xff0D121B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff10B981).withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.north_east,
                  size: 14,
                  color: Color(0xff10B981),
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
