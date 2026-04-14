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
    return _socketManager.listen<List<SlotModel>>(
      'slot_update',
      (data) {
        final List<dynamic> slotsJson = data['slots'] as List<dynamic>;
        return slotsJson.map((json) => SlotModel.fromSocketEvent(json)).toList();
      },
    );
  }
}
