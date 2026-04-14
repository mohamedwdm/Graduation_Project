import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_slots_usecase.dart';
import '../../../domain/usecases/watch_slots_usecase.dart';
import 'slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  final GetSlotsUseCase _getSlotsUseCase;
  final WatchSlotsUseCase _watchSlotsUseCase;
  StreamSubscription? _slotsSubscription;

  SlotsCubit({
    required GetSlotsUseCase getSlotsUseCase,
    required WatchSlotsUseCase watchSlotsUseCase,
  })  : _getSlotsUseCase = getSlotsUseCase,
        _watchSlotsUseCase = watchSlotsUseCase,
        super(const SlotsInitial());

  Future<void> loadSlots() async {
    emit(const SlotsLoading());

    final result = await _getSlotsUseCase(const NoParams());

    result.fold(
      (failure) => emit(SlotsError(failure.message)),
      (slots) {
        emit(SlotsLoaded(slots));
        _watchLiveUpdates();
      },
    );
  }

  void _watchLiveUpdates() {
    _slotsSubscription?.cancel();
    _slotsSubscription = _watchSlotsUseCase(const NoParams()).listen((result) {
      result.fold(
        (failure) => emit(SlotsError(failure.message)),
        (slots) => emit(SlotsLoaded(slots)),
      );
    });
  }

  @override
  Future<void> close() {
    _slotsSubscription?.cancel();
    return super.close();
  }
}
