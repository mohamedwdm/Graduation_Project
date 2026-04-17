import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/manage_slots_repository.dart';
import '../datasources/manage_slots_datasource.dart';

class ManageSlotsRepositoryImpl implements ManageSlotsRepository {
  final ManageSlotsDataSource dataSource;
  final NetworkInfo networkInfo;

  ManageSlotsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SlotEntity>>> getSlots(int floor) async {
    try {
      // In Mock-First, we might skip network check for mock datasource or handle it generally
      // For now, if it's the actual implementation, we'd check networkInfo.isConnected
      final slots = await dataSource.getSlots(floor);
      return Right(slots.cast<SlotEntity>().toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
