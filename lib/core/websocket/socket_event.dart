import '../utils/typedefs.dart';

class SocketEvent {
  final String type;
  final JsonMap data;
  final DateTime timestamp;

  SocketEvent({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SocketEvent.fromJson(JsonMap json) {
    return SocketEvent(
      type: json['type'] as String,
      data: json['data'] as JsonMap,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
