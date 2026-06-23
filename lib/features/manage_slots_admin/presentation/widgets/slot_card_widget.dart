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
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slot ${slot.name}",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              _StatusBadge(status: slot.status),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.layers_outlined,
            label: 'Floor',
            value: slot.floor.toString(),
          ),
          const SizedBox(height: 4),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: slot.location,
          ),
          // const SizedBox(height: 12),
          // Row(
          //   children: [
          //     if (slot.isEV)
          //       _FeatureChip(
          //         icon: Icons.electric_bolt,
          //         label: "EV Charging",
          //       ),
          //     if (slot.isEV && slot.isAccessible) const SizedBox(width: 12),
          //     if (slot.isAccessible)
          //       _FeatureChip(
          //         icon: Icons.accessible,
          //         label: "Accessible",
          //       ),
          //     if (!slot.isEV && !slot.isAccessible)
          //       Text(
          //         "No additional features",
          //         style: GoogleFonts.spaceGrotesk(
          //           fontWeight: FontWeight.w400,
          //           fontSize: 12,
          //           color: const Color(0xff94A3B8),
          //         ),
          //       ),
          //   ],
          // ),
          const SizedBox(height: 16),
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
                    side:
                        const BorderSide(color: Color(0xff0F172A), width: 1.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xff0F172A)),
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
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case SlotStatus.available:
        statusColor = const Color(0xFF15803D);
        statusText = "Available";
        statusIcon = Icons.check_circle;
        break;
      case SlotStatus.maintenance:
        statusColor = const Color(0xFFF59E0B);
        statusText = "Maintenance";
        statusIcon = Icons.info_outline;
        break;
      case SlotStatus.occupied:
        statusColor =  const Color(0xFFDC2626);
        statusText = "Occupied";
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: GoogleFonts.spaceGrotesk(
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
