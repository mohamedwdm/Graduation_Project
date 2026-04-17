import 'package:equatable/equatable.dart';

class CameraStatusEntity extends Equatable {
  final String id;
  final String label;
  final bool isOnline;
  final String lastEvent;
  final DateTime lastEventTime;

  const CameraStatusEntity({
    required this.id,
    required this.label,
    required this.isOnline,
    required this.lastEvent,
    required this.lastEventTime,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(lastEventTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'just now';
  }

  @override
  List<Object?> get props => [id, label, isOnline, lastEvent, lastEventTime];
}
