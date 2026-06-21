import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/network/api_constants.dart';
import '../models/parking_overview_model.dart';
import 'parking_overview_datasource.dart';

import '../models/camera_status_model.dart';
import '../models/activity_log_entry_model.dart';

class ParkingOverviewRemoteDataSourceImpl implements ParkingOverviewDataSource {
  final ApiClient _apiClient;

  ParkingOverviewRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ParkingOverviewModel> fetchParkingOverview() async {
    try {
      final responses = await Future.wait([
        _apiClient.get('/admin/summary'),
        _apiClient.get('/cameras/all'),
        _apiClient.get('/admin/analytics/history'),
      ]);

      final summaryRes = responses[0];
      final camerasRes = responses[1];
      final historyRes = responses[2];

      if (summaryRes.statusCode == 200 &&
          camerasRes.statusCode == 200 &&
          historyRes.statusCode == 200) {

        final summaryData = summaryRes.data as Map<String, dynamic>? ?? {};
        final camerasList = (camerasRes.data as List?) ?? [];
        final historyList = (historyRes.data['data'] as List?) ?? [];

        final totalSlots = summaryData['total_slots'] as int? ?? 0;
        final occupiedSlots = summaryData['occupied_slots'] as int? ?? 0;
        final freeSlots = summaryData['available_slots'] as int? ?? 0;

        final List<CameraStatusModel> cameras = [];
        for (final c in camerasList) {
          final map = c as Map<String, dynamic>? ?? {};
          cameras.add(CameraStatusModel(
            id: (map['id'] ?? '').toString(),
            label: (map['name'] ?? '').toString(),
            isOnline: map['is_active'] as bool? ?? false,
            lastEvent: 'Monitoring active',
            lastEventTime: DateTime.now(),
          ));
        }

        final List<ActivityLogEntryModel> activityLog = [];
        int index = 1;
        for (final h in historyList) {
          if (activityLog.length >= 15) break; // Limit log list size for layout
          final map = h as Map<String, dynamic>? ?? {};
          final plate = map['plate_number'] ?? '';
          final slotCode = map['slot'] ?? '';
          final isActive = map['is_active'] as bool? ?? false;
          final timeStr = isActive ? (map['entry_time'] as String?) : (map['exit_time'] as String?);

          activityLog.add(ActivityLogEntryModel(
            id: 'log_$index',
            eventType: isActive ? 'Entry' : 'Exit',
            description: isActive
                ? 'Vehicle $plate parked at slot $slotCode.'
                : 'Vehicle $plate left slot $slotCode.',
            timestamp: timeStr != null ? DateTime.parse(timeStr) : DateTime.now(),
          ));
          index++;
        }

        return ParkingOverviewModel(
          totalSlots: totalSlots,
          freeSlots: freeSlots,
          occupiedSlots: occupiedSlots,
          cameraCount: cameras.length,
          cameras: cameras,
          activityLog: activityLog,
          mapImageUrl: '',
        );
      } else if (summaryRes.statusCode == 403 ||
                 camerasRes.statusCode == 403 ||
                 historyRes.statusCode == 403) {
        throw const ForbiddenException();
      } else {
        throw ServerException('Failed to fetch parking overview from backend');
      }
    } on ForbiddenException {
      rethrow;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
