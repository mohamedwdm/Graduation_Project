import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import '../../../domain/entities/car_entity.dart';
import '../../../domain/usecases/search_cars_usecase.dart';
import '../../../domain/usecases/get_floors_usecase.dart';
import '../../../domain/usecases/get_sections_usecase.dart';
import 'find_car_state.dart';

class FindCarCubit extends Cubit<FindCarState> {
  final SearchCarsUseCase _searchCarsUseCase;
  final FindCarGetFloorsUseCase _getFloorsUseCase;
  final FindCarGetSectionsUseCase _getSectionsUseCase;

  String _query = '';
  String? _floor;
  String? _section;

  List<String> _floors = [];
  List<String> _sections = [];

  String get query => _query;
  String? get floor => _floor;
  String? get section => _section;
  List<String> get floorsList => _floors;
  List<String> get sectionsList => _sections;

  FindCarCubit({
    required SearchCarsUseCase searchCarsUseCase,
    required FindCarGetFloorsUseCase getFloorsUseCase,
    required FindCarGetSectionsUseCase getSectionsUseCase,
  })  : _searchCarsUseCase = searchCarsUseCase,
        _getFloorsUseCase = getFloorsUseCase,
        _getSectionsUseCase = getSectionsUseCase,
        super(const FindCarInitial()) {
    loadFilters();
  }

  Future<void> loadFilters() async {
    final floorsResult = await _getFloorsUseCase(const NoParams());
    final sectionsResult = await _getSectionsUseCase(const NoParams());

    floorsResult.fold((_) {}, (list) => _floors = list);
    sectionsResult.fold((_) {}, (list) => _sections = list);

    emit(state);
  }

  Future<void> searchCars(String query) async {
    _query = query;
    await _performSearch();
  }

  Future<void> updateFloor(String? newFloor) async {
    _floor = newFloor;
    await _performSearch();
  }

  Future<void> updateSection(String? newSection) async {
    _section = newSection;
    await _performSearch();
  }

  Future<void> clearSearch() async {
    _query = '';
    _floor = null;
    _section = null;
    emit(const FindCarInitial());
  }

  Future<void> _performSearch() async {
    final trimmedQuery = _query.trim();
    if (trimmedQuery.isEmpty && (_floor == null || _floor!.isEmpty) && (_section == null || _section!.isEmpty)) {
      emit(const FindCarInitial());
      return;
    }
    emit(const FindCarLoading());
    final result = await _searchCarsUseCase(SearchCarsParams(
      query: trimmedQuery,
      floor: _floor,
      section: _section,
    ));
    result.fold(
      (failure) => emit(FindCarError(failure.message)),
      (backendCars) => emit(FindCarLoaded(backendCars)),
    );
  }
}
