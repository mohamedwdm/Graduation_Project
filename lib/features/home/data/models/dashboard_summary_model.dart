import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.totalSlots,
    required super.availableSlots,
    required super.userName,
    super.currentReservationId,
    super.lastActivity,
  });

  factory DashboardSummaryModel.fromJson(JsonMap json) {
    return DashboardSummaryModel(
      totalSlots: json['total_slots'] as int,
      availableSlots: json['available_slots'] as int,
      userName: json['user_name'] as String,
      currentReservationId: json['current_reservation_id'] as String?,
      lastActivity: json['last_activity'] != null
          ? DateTime.parse(json['last_activity'] as String)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'total_slots': totalSlots,
      'available_slots': availableSlots,
      'user_name': userName,
      'current_reservation_id': currentReservationId,
      'last_activity': lastActivity?.toIso8601String(),
    };
  }
}
