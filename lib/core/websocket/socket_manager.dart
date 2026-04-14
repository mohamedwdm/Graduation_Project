import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'socket_event.dart';

enum SocketConnectionState { disconnected, connecting, connected, reconnecting }

class SocketManager {
  final String _baseUrl;
  String? _authToken;
  WebSocketChannel? _channel;
  final StreamController<SocketEvent> _messageController = StreamController<SocketEvent>.broadcast();
  final StreamController<SocketConnectionState> _stateController = StreamController<SocketConnectionState>.broadcast();
  
  SocketConnectionState _state = SocketConnectionState.disconnected;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;

  SocketManager({required String baseUrl, String? authToken})
      : _baseUrl = baseUrl,
        _authToken = authToken;

  Stream<SocketEvent> get messages$ => _messageController.stream;
  Stream<SocketConnectionState> get state$ => _stateController.stream;
  SocketConnectionState get currentState => _state;

  void updateToken(String token) {
    _authToken = token;
    if (_state == SocketConnectionState.connected) {
      reconnect();
    }
  }

  void connect() {
    if (_state == SocketConnectionState.connected || _state == SocketConnectionState.connecting) return;
    
    _updateState(SocketConnectionState.connecting);
    
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: _authToken != null ? {'token': _authToken} : null,
      );
      
      _channel = WebSocketChannel.connect(uri);
      
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
      
      _updateState(SocketConnectionState.connected);
      _reconnectAttempts = 0;
    } catch (e) {
      log('Socket Connection Error: $e');
      _onError(e);
    }
  }

  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString());
      final event = SocketEvent.fromJson(data);
      _messageController.add(event);
    } catch (e) {
      log('Socket parsing error: $e');
    }
  }

  void _onError(dynamic error) {
    log('Socket Error: $error');
    _handleReconnect();
  }

  void _onDone() {
    log('Socket Connection Closed');
    if (_state != SocketConnectionState.disconnected) {
      _handleReconnect();
    }
  }

  void _handleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _updateState(SocketConnectionState.disconnected);
      return;
    }

    _updateState(SocketConnectionState.reconnecting);
    _reconnectAttempts++;
    
    final delay = Duration(seconds: (1 << _reconnectAttempts).clamp(1, 30));
    log('Attempting socket reconnection in ${delay.inSeconds}s (Attempt $_reconnectAttempts)');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  void reconnect() {
    disconnect();
    connect();
  }

  void disconnect() {
    _updateState(SocketConnectionState.disconnected);
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }

  void send(String eventType, Map<String, dynamic> data) {
    if (_state != SocketConnectionState.connected) {
      log('Cannot send message: Socket not connected');
      return;
    }
    
    final event = SocketEvent(type: eventType, data: data);
    _channel?.sink.add(jsonEncode(event.toJson()));
  }

  Stream<T> listen<T>(String eventType, T Function(Map<String, dynamic>) parser) {
    return messages$
        .where((event) => event.type == eventType)
        .map((event) => parser(event.data));
  }

  void _updateState(SocketConnectionState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _stateController.close();
  }
}
