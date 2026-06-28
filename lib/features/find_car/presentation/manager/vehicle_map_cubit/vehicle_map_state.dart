import 'package:equatable/equatable.dart';
import '../../../domain/entities/vehicle_map_entity.dart';

abstract class VehicleMapState extends Equatable {
  const VehicleMapState();

  @override
  List<Object?> get props => [];
}

class VehicleMapInitial extends VehicleMapState {
  const VehicleMapInitial();
}

class VehicleMapLoading extends VehicleMapState {
  const VehicleMapLoading();
}

class VehicleMapLoaded extends VehicleMapState {
  final VehicleMapEntity mapEntity;

  const VehicleMapLoaded(this.mapEntity);

  @override
  List<Object?> get props => [mapEntity];
}

class VehicleMapError extends VehicleMapState {
  final String message;

  const VehicleMapError(this.message);

  @override
  List<Object?> get props => [message];
}
