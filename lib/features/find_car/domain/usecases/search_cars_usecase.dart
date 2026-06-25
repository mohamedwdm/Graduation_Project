import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/car_entity.dart';
import '../repositories/find_car_repository.dart';

class SearchCarsUseCase implements UseCase<List<CarEntity>, SearchCarsParams> {
  final FindCarRepository _repository;

  SearchCarsUseCase(this._repository);

  @override
  FutureEither<List<CarEntity>> call(SearchCarsParams params) {
    return _repository.searchCars(params.query, floor: params.floor, section: params.section);
  }
}

class SearchCarsParams extends Equatable {
  final String query;
  final String? floor;
  final String? section;

  const SearchCarsParams({
    required this.query,
    this.floor,
    this.section,
  });

  @override
  List<Object?> get props => [query, floor, section];
}
