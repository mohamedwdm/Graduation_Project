import 'package:equatable/equatable.dart';

class SavedCarEntity extends Equatable {
  final String id;
  final String model;
  final String color;
  final String plateNumber;

  const SavedCarEntity({
    required this.id,
    required this.model,
    required this.color,
    required this.plateNumber,
  });

  @override
  List<Object?> get props => [id, model, color, plateNumber];
}
