import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OccupancyDonutChart extends StatelessWidget {
  final double percent; // 0.0 to 100.0 (percentage value)

  const OccupancyDonutChart({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentTextColor = isDark ? Colors.white : const Color(0xff0D121B);
    final bgCircleColor = isDark ? const Color(0xff334155) : const Color(0xffF3F4F6);
    final cleanPercent = (percent.isNaN || percent.isInfinite) ? 0.0 : percent.clamp(0.0, 100.0);

    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(128, 128),
            painter: _DonutPainter(percent: cleanPercent, bgCircleColor: bgCircleColor),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${cleanPercent.toStringAsFixed(1)}%',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: percentTextColor,
                ),
              ),
              Text(
                'FILLED',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percent;
  final Color bgCircleColor;

  _DonutPainter({required this.percent, required this.bgCircleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = bgCircleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = const Color(0xff1152D4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -pi / 2, // Start from top (-90 degrees)
      2 * pi * (percent / 100.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.bgCircleColor != bgCircleColor;
  }
}
