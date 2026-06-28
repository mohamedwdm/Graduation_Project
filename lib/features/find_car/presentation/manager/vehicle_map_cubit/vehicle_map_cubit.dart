import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_vehicle_map_usecase.dart';
import 'vehicle_map_state.dart';

class VehicleMapCubit extends Cubit<VehicleMapState> {
  final GetVehicleMapUseCase _getVehicleMapUseCase;

  VehicleMapCubit({
    required GetVehicleMapUseCase getVehicleMapUseCase,
  })  : _getVehicleMapUseCase = getVehicleMapUseCase,
        super(const VehicleMapInitial());

  Future<void> fetchVehicleMap(String plate) async {
    emit(const VehicleMapLoading());
    final result = await _getVehicleMapUseCase(plate);
    result.fold(
      (failure) => emit(VehicleMapError(failure.message)),
      (mapEntity) => emit(VehicleMapLoaded(mapEntity)),
    );
  }
}
