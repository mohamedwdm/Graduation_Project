import '../models/parking_overview_model.dart';
import '../models/camera_status_model.dart';
import '../models/activity_log_entry_model.dart';
import 'parking_overview_datasource.dart';

class ParkingOverviewMockDataSourceImpl implements ParkingOverviewDataSource {
  @override
  Future<ParkingOverviewModel> fetchParkingOverview() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    return ParkingOverviewModel(
      totalSlots: 250,
      freeSlots: 82,
      occupiedSlots: 168,
      cameraCount: 16,
      mapImageUrl: 'assets/images/parking_map_placeholder.png',
      cameras: [
        CameraStatusModel(
          id: 'cam_1',
          label: 'Camera C1',
          isOnline: true,
          lastEvent: 'Slot B-12 Freed',
          lastEventTime: now.subtract(const Duration(minutes: 8)),
        ),
        CameraStatusModel(
          id: 'cam_2',
          label: 'Camera C2',
          isOnline: false,
          lastEvent: 'Camera C2 Offline',
          lastEventTime: now.subtract(const Duration(minutes: 8)),
        ),
        CameraStatusModel(
          id: 'cam_3',
          label: 'Camera C3',
          isOnline: true,
          lastEvent: 'Slot A-4 Occupied',
          lastEventTime: now.subtract(const Duration(minutes: 22)),
        ),
        CameraStatusModel(
          id: 'cam_4',
          label: 'Camera C4',
          isOnline: false,
          lastEvent: 'Camera C4 Offline',
          lastEventTime: now.subtract(const Duration(minutes: 35)),
        ),
      ],
      activityLog: [
        ActivityLogEntryModel(
          id: 'log_1',
          eventType: 'camera_online',
          description: 'Camera C1 Online',
          timestamp: now.subtract(const Duration(minutes: 8)),
        ),
        ActivityLogEntryModel(
          id: 'log_2',
          eventType: 'camera_offline',
          description: 'Camera C2 Offline',
          timestamp: now.subtract(const Duration(minutes: 8)),
        ),
        ActivityLogEntryModel(
          id: 'log_3',
          eventType: 'slot_update',
          description: 'Slot A-4 Occupied',
          timestamp: now.subtract(const Duration(minutes: 22)),
        ),
        ActivityLogEntryModel(
          id: 'log_4',
          eventType: 'camera_offline',
          description: 'Camera C4 Offline',
          timestamp: now.subtract(const Duration(minutes: 35)),
        ),
      ],
    );
  }
}
