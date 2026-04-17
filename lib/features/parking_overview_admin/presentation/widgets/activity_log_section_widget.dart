import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/activity_log_entry_entity.dart';
import '../../domain/entities/camera_status_entity.dart';
import 'camera_status_tile_widget.dart';

class ActivityLogSectionWidget extends StatelessWidget {
  final List<ActivityLogEntryEntity> activities;

  const ActivityLogSectionWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Log',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0F172A),
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
            // Normalize activity entry to CameraStatusEntity for reuse of CameraStatusTileWidget
            final normalizedCamera = CameraStatusEntity(
              id: entry.id,
              label: entry.description,
              isOnline: entry.eventType == 'camera_online' || entry.eventType == 'slot_update',
              lastEvent: entry.eventType,
              lastEventTime: entry.timestamp,
            );
            return CameraStatusTileWidget(camera: normalizedCamera);
          },
        ),
      ],
    );
  }
}
