import 'package:flutter/material.dart';
import 'package:go2car/core/di/injection_container.dart';
import 'package:go_router/go_router.dart';

import 'package:go2car/core/network/api_client.dart';
import '../../../../find_car/domain/entities/car_entity.dart';
import '../../../../find_car/presentation/widgets/vehicle_map_dialog.dart';
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

    final String statusText;
    final Color statusBgColor;
    final Color statusTextColor;
    final IconData statusIcon;

    if (slot.status == 'available') {
      statusText = 'Available';
      statusBgColor = isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7);
      statusTextColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
      statusIcon = Icons.check_circle;
    } else if (slot.status == 'booked') {
      statusText = 'Booked';
      statusBgColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
      statusTextColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8);
      statusIcon = Icons.bookmark_added;
    } else {
      statusText = 'Occupied';
      statusBgColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
      statusTextColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
      statusIcon = Icons.cancel;
    }

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
                    'Slot ${slot.slotNumber}',
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
                      statusIcon,
                      size: 16,
                      color: statusTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
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
                        final isGuest = sl<ApiClient>().isGuest;
                        if (isGuest) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text(
                                'Authentication Required',
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'You are currently in Guest Mode. Please sign in or register to reserve parking slots.',
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    context.go('/');
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      color: Color(0xff00A24F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          context.push('/reserve-slot?slotCode=${slot.slotId}');
                        }
                      } else {
                        final tempCar = CarEntity(
                          id: slot.id,
                          model: '',
                          color: '',
                          plateNumber: slot.label,
                          parkingLocation: 'Floor ${slot.floor}, ${slot.sectionNameDisplay} - Slot ${slot.slotNumber}',
                          slotId: int.tryParse(slot.id),
                        );
                        VehicleMapDialog.show(context, tempCar);
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
                    onPressed: () {
                      final tempCar = CarEntity(
                        id: slot.id,
                        model: '',
                        color: '',
                        plateNumber: slot.label,
                        parkingLocation: 'Floor ${slot.floor}, ${slot.sectionNameDisplay} - Slot ${slot.slotNumber}',
                        slotId: int.tryParse(slot.id),
                      );
                      VehicleMapDialog.show(context, tempCar);
                    },
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
