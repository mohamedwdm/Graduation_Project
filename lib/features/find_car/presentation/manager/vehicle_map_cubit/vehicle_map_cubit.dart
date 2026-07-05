import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_vehicle_map_usecase.dart';
import 'vehicle_map_state.dart';

class VehicleMapCubit extends Cubit<VehicleMapState> {
  final GetVehicleMapUseCase _getVehicleMapUseCase;

  VehicleMapCubit({
    required GetVehicleMapUseCase getVehicleMapUseCase,
  })  : _getVehicleMapUseCase = getVehicleMapUseCase,
        super(const VehicleMapInitial());

  Future<void> fetchVehicleMap({
    int? slotId,
    String? plate,
    required String floor,
    required String section,
    required String slot,
  }) async {
    emit(const VehicleMapLoading());
    final result = await _getVehicleMapUseCase(GetVehicleMapParams(
      slotId: slotId,
      plate: plate,
      floor: floor,
      section: section,
      slot: slot,
    ));
    result.fold(
      (failure) => emit(VehicleMapError(failure.message)),
      (mapEntity) => emit(VehicleMapLoaded(mapEntity)),
    );
  }
}
