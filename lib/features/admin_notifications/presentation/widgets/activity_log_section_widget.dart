import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/activity_log_entry_entity.dart';

class ActivityLogSectionWidget extends StatelessWidget {
  final List<ActivityLogEntryEntity> activities;

  const ActivityLogSectionWidget({
    super.key,
    required this.activities,
  });

  String _formatDateTime(DateTime dt) {
    final year = dt.year;
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xff0F172A);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final secondaryTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: secondaryTextColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No detection logs available.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detection Logs',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = activities[index];
            final formattedTime = entry.detectedAt != null
                ? _formatDateTime(entry.detectedAt!.toLocal())
                : 'Unknown time';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: entry.flaggedForReview
                      ? (isDark ? Colors.redAccent.withOpacity(0.4) : Colors.red.shade200)
                      : borderColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
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
                          Icon(
                            Icons.videocam,
                            size: 18,
                            color: isDark ? Colors.greenAccent : const Color(0xff00A24F),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.cameraName,
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: titleColor,
                            ),
                          ),
                        ],
                      ),
                      if (entry.flaggedForReview)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 12,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Flagged',
                                style: GoogleFonts.spaceGrotesk(
                                  color: isDark ? Colors.redAccent : Colors.red.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (entry.slotCode != null)
                        _buildDetailItem(
                          context,
                          Icons.local_parking,
                          'Slot',
                          entry.slotCode!,
                        ),
                      if (entry.plateNumber != null && entry.plateNumber!.isNotEmpty)
                        _buildDetailItem(
                          context,
                          Icons.tag,
                          'Plate',
                          entry.plateNumber!,
                        ),
                      if (entry.vehicleType != null && entry.vehicleType!.isNotEmpty)
                        _buildDetailItem(
                          context,
                          Icons.directions_car,
                          'Type',
                          entry.vehicleType!,
                        ),
                      if (entry.vehicleColor != null && entry.vehicleColor!.isNotEmpty)
                        _buildDetailItem(
                          context,
                          Icons.palette,
                          'Color',
                          entry.vehicleColor!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: borderColor, height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detected:',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: titleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueColor = isDark ? Colors.white : const Color(0xff0F172A);
    final labelColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: labelColor),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
