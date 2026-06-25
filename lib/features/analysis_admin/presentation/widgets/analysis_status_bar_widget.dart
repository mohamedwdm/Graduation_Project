import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisStatusBarWidget extends StatelessWidget {
  final String label;
  final int count;
  final double progress; // 0.0 to 1.0
  final Color activeColor;
  final Color shadowColor;

  const AnalysisStatusBarWidget({
    super.key,
    required this.label,
    required this.count,
    required this.progress,
    required this.activeColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white : const Color(0xff0D121B);
    final trackColor = isDark ? const Color(0xff334155) : const Color(0xffF3F4F6);
    final cleanProgress = (progress.isNaN || progress.isInfinite) ? 0.0 : progress.clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
            const Spacer(),
            Text(
              '$count',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: activeColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: cleanProgress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
