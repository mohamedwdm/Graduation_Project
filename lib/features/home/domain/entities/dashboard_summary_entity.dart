import 'package:equatable/equatable.dart';

class DashboardSummaryEntity extends Equatable {
  final int totalSlots;
  final int availableSlots;
  final String userName;
  final String? currentReservationId;
  final DateTime? lastActivity;

  const DashboardSummaryEntity({
    required this.totalSlots,
    required this.availableSlots,
    required this.userName,
    this.currentReservationId,
    this.lastActivity,
  });

  @override
  List<Object?> get props => [
        totalSlots,
        availableSlots,
        userName,
        currentReservationId,
        lastActivity,
      ];
}
