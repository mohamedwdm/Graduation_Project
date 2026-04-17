import 'package:equatable/equatable.dart';

class AnalysisDataEntity extends Equatable {
  final double occupancyPercent;
  final int occupiedCount;
  final int freeCount;
  final int totalCapacity;
  
  final int carsParkedTotal;
  final double carsParkedChange;
  
  final int carsLeftTotal;
  final double carsLeftChange;
  
  final int onlineCameras;
  final int offlineCameras;

  const AnalysisDataEntity({
    required this.occupancyPercent,
    required this.occupiedCount,
    required this.freeCount,
    required this.totalCapacity,
    required this.carsParkedTotal,
    required this.carsParkedChange,
    required this.carsLeftTotal,
    required this.carsLeftChange,
    required this.onlineCameras,
    required this.offlineCameras,
  });

  @override
  List<Object?> get props => [
        occupancyPercent,
        occupiedCount,
        freeCount,
        totalCapacity,
        carsParkedTotal,
        carsParkedChange,
        carsLeftTotal,
        carsLeftChange,
        onlineCameras,
        offlineCameras,
      ];
}
