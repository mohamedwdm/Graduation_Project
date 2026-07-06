import '../../../../core/network/api_client.dart';
import '../models/reservation_response_model.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationResponseModel> createReservation({
    required String slotCode,
    required String plateNumber,
    required DateTime startTime,
    required DateTime endTime,
  });

  Future<List<ReservationResponseModel>> fetchMyReservations();

  Future<ReservationResponseModel> cancelReservation(int reservationId);

  Future<List<ReservationResponseModel>> fetchAllReservations();

  Future<ReservationResponseModel> approveReservation(int reservationId);

  Future<ReservationResponseModel> rejectReservation(int reservationId);
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final ApiClient _apiClient;

  ReservationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ReservationResponseModel> createReservation({
    required String slotCode,
    required String plateNumber,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final response = await _apiClient.post(
      '/reservations/',
      data: {
        'slot_code': slotCode,
        'plate_number': plateNumber,
        'start_time': startTime.toUtc().toIso8601String(),
        'end_time': endTime.toUtc().toIso8601String(),
      },
    );
    final data = response.data as Map<String, dynamic>;
    return ReservationResponseModel.fromJson(data);
  }

  @override
  Future<List<ReservationResponseModel>> fetchMyReservations() async {
    final response = await _apiClient.get('/reservations/me');
    final dataList = response.data as List;
    return dataList
        .map((json) => ReservationResponseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReservationResponseModel> cancelReservation(int reservationId) async {
    final response = await _apiClient.post('/reservations/$reservationId/cancel');
    final data = response.data as Map<String, dynamic>;
    return ReservationResponseModel.fromJson(data);
  }

  @override
  Future<List<ReservationResponseModel>> fetchAllReservations() async {
    final response = await _apiClient.get('/reservations/all');
    final dataList = response.data as List;
    return dataList
        .map((json) => ReservationResponseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReservationResponseModel> approveReservation(int reservationId) async {
    final response = await _apiClient.post('/reservations/$reservationId/approve');
    final data = response.data as Map<String, dynamic>;
    return ReservationResponseModel.fromJson(data);
  }

  @override
  Future<ReservationResponseModel> rejectReservation(int reservationId) async {
    final response = await _apiClient.post('/reservations/$reservationId/reject');
    final data = response.data as Map<String, dynamic>;
    return ReservationResponseModel.fromJson(data);
  }
}
