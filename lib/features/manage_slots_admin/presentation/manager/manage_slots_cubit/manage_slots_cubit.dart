import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import '../../../domain/usecases/get_manage_slots_usecase.dart';
import '../../../domain/usecases/add_slot_usecase.dart';
import '../../../domain/usecases/get_sections_usecase.dart';
import '../../../domain/usecases/update_slot_type_usecase.dart';
import 'manage_slots_state.dart';

class ManageSlotsCubit extends Cubit<ManageSlotsState> {
  final GetManageSlotsUseCase getManageSlotsUseCase;
  final AddSlotUseCase addSlotUseCase;
  final GetSectionsUseCase getSectionsUseCase;
  final UpdateSlotTypeUseCase updateSlotTypeUseCase;

  ManageSlotsCubit({
    required this.getManageSlotsUseCase,
    required this.addSlotUseCase,
    required this.getSectionsUseCase,
    required this.updateSlotTypeUseCase,
  }) : super(ManageSlotsInitial());

  Future<void> fetchSlots(int floor, {bool showLoading = true}) async {
    if (showLoading) {
      emit(ManageSlotsLoading());
    }

    final result = await getManageSlotsUseCase(floor);

    result.fold(
      (failure) => emit(ManageSlotsError(message: failure.message)),
      (slots) => emit(ManageSlotsLoaded(slots: slots, floor: floor)),
    );
  }

  Future<bool> addSlot({required String slotCode, required int sectionId, required int currentFloor}) async {
    final result = await addSlotUseCase(AddSlotParams(slotCode: slotCode, sectionId: sectionId));
    return result.fold(
      (failure) {
        emit(ManageSlotsError(message: failure.message));
        return false;
      },
      (_) async {
        await fetchSlots(currentFloor);
        return true;
      },
    );
  }

  Future<List<Map<String, dynamic>>> loadSections() async {
    final result = await getSectionsUseCase(const NoParams());
    return result.fold(
      (failure) => [],
      (sections) => sections,
    );
  }

  Future<bool> updateSlotType({
    required String slotId,
    required String slotType,
    required int currentFloor,
  }) async {
    final result = await updateSlotTypeUseCase(
      UpdateSlotTypeParams(slotId: slotId, slotType: slotType),
    );
    return result.fold(
      (failure) {
        emit(ManageSlotsError(message: failure.message));
        return false;
      },
      (_) async {
        await fetchSlots(currentFloor, showLoading: false);
        return true;
      },
    );
  }
}
