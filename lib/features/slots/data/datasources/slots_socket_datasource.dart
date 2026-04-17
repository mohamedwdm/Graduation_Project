import '../../../../core/websocket/socket_manager.dart';
import '../models/slot_model.dart';

abstract class SlotsSocketDataSource {
  Stream<List<SlotModel>> watchSlotUpdates();
  void connect();
  void disconnect();
}

class SlotsSocketDataSourceImpl implements SlotsSocketDataSource {
  final SocketManager _socketManager;

  SlotsSocketDataSourceImpl({required SocketManager socketManager})
      : _socketManager = socketManager;

  @override
  void connect() {
    _socketManager.connect();
  }

  @override
  void disconnect() {
    _socketManager.disconnect();
  }

  @override
  Stream<List<SlotModel>> watchSlotUpdates() {
    // Simulated remote stream
    return Stream.periodic(const Duration(seconds: 5), (tick) {
      final List<Map<String, dynamic>> mockSlots = List.generate(24, (index) {
        final floor = (index / 10).floor() + 1;
        final section = String.fromCharCode(65 + (index % 3));
        
        // Randomly flip occupancy for one slot every 5 seconds to simulate activity
        bool isOccupied = index % 3 == 0;
        if (tick % 24 == index) {
          isOccupied = !isOccupied;
        }
        
        return {
          'id': 'slot_$index',
          'label': '$section-${index + 1}',
          'is_occupied': isOccupied,
          'floor': floor,
          'section': 'Section $section',
          'has_ev_charging': index % 5 == 0,
          'is_accessible': index % 8 == 0,
          'last_updated': DateTime.now().toIso8601String(),
        };
      });
      return mockSlots.map((json) => SlotModel.fromSocketEvent(json)).toList();
    }).asBroadcastStream();
  }
}
