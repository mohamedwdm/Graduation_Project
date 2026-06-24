import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/slot_entity.dart';

class SlotItemCard extends StatelessWidget {
  final SlotEntity slot;

  const SlotItemCard({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.02);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final noteTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    final statusBgColor = slot.isAvailable
        ? (isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7))
        : (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2));
    final statusTextColor = slot.isAvailable
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D))
        : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626));

    final navigateBtnColor = slot.isAvailable
        ? const Color(0xff00A24F)
        : (isDark ? const Color(0xFF334155) : const Color(0xFF0F172A));

    final mapBtnBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final mapBtnTextColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.slotId,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: titleTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slot.locationNote,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: noteTextColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  children: [
                    Icon(
                      slot.isAvailable ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: statusTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slot.isAvailable ? 'Available' : 'Occupied',
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: statusTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (slot.hasEvCharging || slot.isAccessible) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (slot.hasEvCharging)
                  _buildFeatureTag(context, Icons.bolt_sharp, 'EV Charging'),
                if (slot.hasEvCharging && slot.isAccessible)
                  const SizedBox(width: 16),
                if (slot.isAccessible)
                  _buildFeatureTag(context, Icons.accessible, 'Accessible'),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (slot.isAvailable) {
                        context.push('/reserve-slot?slotCode=${slot.slotId}');
                      } else {
                        // Navigate logic if any
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navigateBtnColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      slot.isAvailable ? 'Reserve Slot' : 'Navigate to Slot',
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mapBtnBgColor,
                      foregroundColor: mapBtnTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View on Map',
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Row(
      children: [
        Icon(icon, size: 19, color: tagColor),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: tagColor,
          ),
        ),
      ],
    );
  }
}
