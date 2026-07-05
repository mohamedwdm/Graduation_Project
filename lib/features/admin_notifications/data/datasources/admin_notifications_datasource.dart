import '../models/parking_overview_model.dart';

abstract class AdminNotificationsDataSource {
  Future<AdminNotificationsModel> fetchAdminNotifications();
}
