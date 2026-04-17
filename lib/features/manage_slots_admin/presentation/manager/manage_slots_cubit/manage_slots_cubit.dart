import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_manage_slots_usecase.dart';
import '../../../domain/entities/slot_entity.dart';
import 'manage_slots_state.dart';

class ManageSlotsCubit extends Cubit<ManageSlotsState> {
  final GetManageSlotsUseCase getManageSlotsUseCase;

  ManageSlotsCubit({required this.getManageSlotsUseCase}) : super(ManageSlotsInitial());

  Future<void> fetchSlots(int floor) async {
    emit(ManageSlotsLoading());

    final result = await getManageSlotsUseCase(floor);

    result.fold(
      (failure) => emit(ManageSlotsError(message: failure.message)),
      (slots) => emit(ManageSlotsLoaded(slots: slots, floor: floor)),
    );
  }
}
