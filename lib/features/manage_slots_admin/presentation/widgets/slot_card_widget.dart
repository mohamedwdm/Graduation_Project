import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/slot_entity.dart';

class SlotCardWidget extends StatelessWidget {
  final SlotEntity slot;

  const SlotCardWidget({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Slot ${slot.name}",
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: const Color(0xff0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              _StatusBadge(status: slot.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            slot.location,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color(0xff64748B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (slot.isEV)
                _FeatureChip(
                  icon: Icons.electric_bolt,
                  label: "EV Charging",
                ),
              if (slot.isEV && slot.isAccessible) const SizedBox(width: 12),
              if (slot.isAccessible)
                _FeatureChip(
                  icon: Icons.accessible,
                  label: "Accessible",
                ),
              if (!slot.isEV && !slot.isAccessible)
                Text(
                  "No additional features",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: const Color(0xff94A3B8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: "Navigate",
                  onPressed: () {},
                  backgroundColor: const Color(0xff0F172A),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: "View Map",
                  onPressed: () {},
                  backgroundColor: const Color(0xffE2E8F0),
                  textColor: const Color(0xff0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xff0F172A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Color(0xff0F172A)),
                      const SizedBox(width: 4),
                      Text(
                        "Status",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: const Color(0xff0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SlotStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case SlotStatus.available:
        bgColor = const Color(0xffDCFCE7);
        textColor = const Color(0xff15803D);
        label = "Available";
        icon = Icons.check_circle_outline;
        break;
      case SlotStatus.maintenance:
        bgColor = const Color(0xffFEF3C7);
        textColor = const Color(0xffB45309);
        label = "Maintenance";
        icon = Icons.settings_outlined;
        break;
      case SlotStatus.occupied:
        bgColor = const Color(0xffEF4444).withOpacity(0.61);
        textColor = const Color(0xff334155);
        label = "Occupied";
        icon = Icons.block_flipped;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(16, 16),
            painter: StatusPulsePainter(color: textColor),
            child: Icon(icon, size: 14, color: textColor),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPulsePainter extends CustomPainter {
  final Color color;

  StatusPulsePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Simple pulse effect - could be animated, but here we just draw a subtle aura
    final Paint paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xff94A3B8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xff475569),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
