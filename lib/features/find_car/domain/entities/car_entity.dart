import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final String id;
  final String model;
  final String color;
  final String plateNumber;
  final String parkingLocation;
  final String? imagePath;

  const CarEntity({
    required this.id,
    required this.model,
    required this.color,
    required this.plateNumber,
    required this.parkingLocation,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, model, color, plateNumber, parkingLocation, imagePath];
}
