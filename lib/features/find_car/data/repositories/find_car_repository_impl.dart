import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/car_entity.dart';
import '../../domain/entities/vehicle_map_entity.dart';
import '../../domain/repositories/find_car_repository.dart';
import '../datasources/find_car_remote_datasource.dart';

class FindCarRepositoryImpl implements FindCarRepository {
  final FindCarRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final bool isMockMode;

  FindCarRepositoryImpl({
    required FindCarRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
    required this.isMockMode,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;



  @override
  FutureEither<List<CarEntity>> searchCars(
    String query, {
    String? floor,
    String? section,
    String? brand,
    String? color,
  }) async {
    if (isMockMode) {
      return const Right([]);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final cars = await _remoteDataSource.searchCars(
        query,
        floor: floor,
        section: section,
        brand: brand,
        color: color,
      );
      return Right(cars);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<String>> getFloors() async {
    if (isMockMode) return const Right([]);
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final floors = await _remoteDataSource.getFloors();
      return Right(floors);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<String>> getSections() async {
    if (isMockMode) return const Right([]);
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final sections = await _remoteDataSource.getSections();
      return Right(sections);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<VehicleMapEntity> getVehicleMap({
    int? slotId,
    String? plate,
    required String floor,
    required String section,
    required String slot,
  }) async {
    String cleanSlotNumber(String s) => s.replaceAll(RegExp(r'slot\s*', caseSensitive: false), '').trim();
    String cleanSectionDisplay(String sec) => sec.replaceAll(RegExp(r'section\s*', caseSensitive: false), '').trim();
    String cleanSectionNameDisplay(String sec) {
      final clean = cleanSectionDisplay(sec);
      return clean.isNotEmpty ? 'Section $clean' : '';
    }

    if (isMockMode) {
      return Right(VehicleMapEntity(
        mapPath: '/static/maps/floor1.png',
        slot: slot,
        section: section,
        floor: floor,
        slotNumber: cleanSlotNumber(slot),
        sectionDisplay: cleanSectionDisplay(section),
        sectionNameDisplay: cleanSectionNameDisplay(section),
      ));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      if (plate != null) {
        final mapData = await _remoteDataSource.getVehicleMap(plate);
        final mapSlot = mapData['slot']?.toString() ?? slot;
        final mapSection = mapData['section']?.toString() ?? section;
        final mapFloor = mapData['floor']?.toString() ?? floor;

        return Right(VehicleMapEntity(
          mapPath: mapData['map_path']?.toString() ?? '',
          slot: mapSlot,
          section: mapSection,
          floor: mapFloor,
          slotNumber: mapData['slot_number']?.toString() ?? cleanSlotNumber(mapSlot),
          sectionDisplay: mapData['section_display']?.toString() ?? cleanSectionDisplay(mapSection),
          sectionNameDisplay: mapData['section_name_display']?.toString() ?? cleanSectionNameDisplay(mapSection),
        ));
      } else if (slotId != null) {
        final mapPath = await _remoteDataSource.getSlotMap(slotId);
        return Right(VehicleMapEntity(
          mapPath: mapPath,
          slot: slot,
          section: section,
          floor: floor,
          slotNumber: cleanSlotNumber(slot),
          sectionDisplay: cleanSectionDisplay(section),
          sectionNameDisplay: cleanSectionNameDisplay(section),
        ));
      } else {
        return const Left(ServerFailure('Neither slotId nor plate was provided'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
