import 'package:flutter/material.dart';
import 'package:go2car/features/slots/data/models/slot_model.dart';

class SlotItemCard extends StatelessWidget {
  final SlotModel slotModel;

  const SlotItemCard({super.key, required this.slotModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                    slotModel.slotId,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slotModel.locationNote,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF64748B),
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
                  color:
                      slotModel.isAvailable
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  children: [
                    Icon(
                      slotModel.isAvailable ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color:
                          slotModel.isAvailable
                              ? const Color(0xFF15803D)
                              : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slotModel.isAvailable ? 'Available' : 'Occupied',
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color:
                            slotModel.isAvailable
                                ? const Color(0xFF15803D)
                                : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (slotModel.hasEvCharging || slotModel.isAccessible) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (slotModel.hasEvCharging)
                  _buildFeatureTag(Icons.bolt_sharp, 'EV Charging'),
                if (slotModel.hasEvCharging && slotModel.isAccessible)
                  const SizedBox(width: 16),
                if (slotModel.isAccessible)
                  _buildFeatureTag(Icons.accessible, 'Accessible'),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Navigate to Slot',
                      style: TextStyle(
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
                      backgroundColor: const Color(0xFFE2E8F0),
                      foregroundColor: const Color(0xFF0F172A),
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

  Widget _buildFeatureTag(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 19, color: const Color(0xFF475569)),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
