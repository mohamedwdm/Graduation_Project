import '../models/parking_overview_model.dart';
import '../models/activity_log_entry_model.dart';
import 'admin_notifications_datasource.dart';

class AdminNotificationsMockDataSourceImpl implements AdminNotificationsDataSource {
  @override
  Future<AdminNotificationsModel> fetchAdminNotifications({bool onlyFlagged = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    final allLogs = [
      ActivityLogEntryModel(
        id: '1',
        cameraName: 'Camera C1',
        slotCode: 'Cam1_Slot_4',
        plateNumber: 'NEWCAR123',
        vehicleColor: 'Blue',
        vehicleType: 'SUV',
        detectedAt: now.subtract(const Duration(minutes: 8)),
        flaggedForReview: false,
      ),
      ActivityLogEntryModel(
        id: '2',
        cameraName: 'Camera C2',
        slotCode: 'Cam2_Slot_1',
        plateNumber: 'ABC-789',
        vehicleColor: 'Black',
        vehicleType: 'Sedan',
        detectedAt: now.subtract(const Duration(minutes: 15)),
        flaggedForReview: true,
      ),
      ActivityLogEntryModel(
        id: '3',
        cameraName: 'Camera C1',
        slotCode: 'Cam1_Slot_3',
        plateNumber: 'XYZ-555',
        vehicleColor: 'White',
        vehicleType: 'Hatchback',
        detectedAt: now.subtract(const Duration(minutes: 22)),
        flaggedForReview: false,
      ),
      ActivityLogEntryModel(
        id: '4',
        cameraName: 'Camera C4',
        slotCode: 'Cam4_Slot_2',
        plateNumber: 'WARN-999',
        vehicleColor: 'Red',
        vehicleType: 'Truck',
        detectedAt: now.subtract(const Duration(minutes: 35)),
        flaggedForReview: true,
      ),
    ];

    final filteredLogs = onlyFlagged
        ? allLogs.where((element) => element.flaggedForReview).toList()
        : allLogs;

    return AdminNotificationsModel(
      activityLog: filteredLogs,
    );
  }
}
