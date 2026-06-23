import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/manage_slots_repository.dart';

class GetSectionsUseCase implements UseCase<List<Map<String, dynamic>>, NoParams> {
  final ManageSlotsRepository repository;

  GetSectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) async {
    return await repository.getSections();
  }
}
