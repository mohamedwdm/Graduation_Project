import 'package:equatable/equatable.dart';

class ActivityLogEntryEntity extends Equatable {
  final String id;
  final String eventType; // 'camera_online' | 'camera_offline' | 'slot_update'
  final String description;
  final DateTime timestamp;

  const ActivityLogEntryEntity({
    required this.id,
    required this.eventType,
    required this.description,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, eventType, description, timestamp];
}
