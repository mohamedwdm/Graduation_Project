import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/analysis_data_entity.dart';

class AnalysisDataModel extends AnalysisDataEntity {
  const AnalysisDataModel({
    required super.occupancyPercent,
    required super.occupiedCount,
    required super.freeCount,
    required super.totalCapacity,
    required super.carsParkedTotal,
    required super.carsParkedChange,
    required super.carsLeftTotal,
    required super.carsLeftChange,
    required super.onlineCameras,
    required super.offlineCameras,
  });

  factory AnalysisDataModel.fromJson(JsonMap json) {
    return AnalysisDataModel(
      occupancyPercent: (json['occupancy_percent'] as num?)?.toDouble() ?? 0.0,
      occupiedCount: json['occupied_count'] ?? 0,
      freeCount: json['free_count'] ?? 0,
      totalCapacity: json['total_capacity'] ?? 0,
      carsParkedTotal: json['cars_parked_total'] ?? 0,
      carsParkedChange: (json['cars_parked_change'] as num?)?.toDouble() ?? 0.0,
      carsLeftTotal: json['cars_left_total'] ?? 0,
      carsLeftChange: (json['cars_left_change'] as num?)?.toDouble() ?? 0.0,
      onlineCameras: json['online_cameras'] ?? 0,
      offlineCameras: json['offline_cameras'] ?? 0,
    );
  }

  JsonMap toJson() {
    return {
      'occupancy_percent': occupancyPercent,
      'occupied_count': occupiedCount,
      'free_count': freeCount,
      'total_capacity': totalCapacity,
      'cars_parked_total': carsParkedTotal,
      'cars_parked_change': carsParkedChange,
      'cars_left_total': carsLeftTotal,
      'cars_left_change': carsLeftChange,
      'online_cameras': onlineCameras,
      'offline_cameras': offlineCameras,
    };
  }
}
