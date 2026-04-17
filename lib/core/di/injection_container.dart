import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/login_as_guest_usecase.dart';
import '../../features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../features/slots/data/datasources/slots_remote_datasource.dart';
import '../../features/slots/data/datasources/slots_socket_datasource.dart';
import '../../features/slots/data/repositories/slots_repository_impl.dart';
import '../../features/slots/domain/repositories/slots_repository.dart';
import '../../features/slots/domain/usecases/get_slots_usecase.dart';
import '../../features/slots/domain/usecases/watch_slots_usecase.dart';
import '../../features/slots/presentation/manager/slots_cubit/slots_cubit.dart';
import '../../features/find_car/data/datasources/find_car_remote_datasource.dart';
import '../../features/find_car/data/repositories/find_car_repository_impl.dart';
import '../../features/find_car/domain/repositories/find_car_repository.dart';
import '../../features/find_car/domain/usecases/find_car_usecase.dart';
import '../../features/find_car/presentation/manager/find_car_cubit/find_car_cubit.dart';
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import '../../features/home/presentation/manager/home_cubit/home_cubit.dart';
import '../../features/parking_overview_admin/data/datasources/parking_overview_datasource.dart';
import '../../features/parking_overview_admin/data/datasources/parking_overview_mock_datasource.dart';
import '../../features/parking_overview_admin/data/datasources/parking_overview_remote_datasource.dart';
import '../../features/parking_overview_admin/data/repositories/parking_overview_repository_impl.dart';
import '../../features/parking_overview_admin/domain/repositories/parking_overview_repository.dart';
import '../../features/parking_overview_admin/domain/usecases/get_parking_overview_usecase.dart';
import '../../features/parking_overview_admin/presentation/manager/parking_overview_cubit/parking_overview_cubit.dart';
import '../config/env_config.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../websocket/socket_manager.dart';
import 'register_module.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final module = RegisterModule();

  // External
  final sharedPreferences = await module.prefs;
  sl.registerSingleton(sharedPreferences);
  sl.registerLazySingleton(() => module.connectivity);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  
  sl.registerLazySingleton(() => ApiClient(
        baseUrl: EnvConfig.instance.apiBaseUrl,
      ));

  sl.registerLazySingleton(() => SocketManager(
        baseUrl: EnvConfig.instance.socketBaseUrl,
      ));

  // Auth Feature
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
        apiClient: sl(),
        socketManager: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => LoginAsGuestUseCase(sl()));

  // Cubit
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        loginAsGuestUseCase: sl(),
      ));

  // Slots Feature
  // Data Sources
  sl.registerLazySingleton<SlotsRemoteDataSource>(
    () => SlotsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<SlotsSocketDataSource>(
    () => SlotsSocketDataSourceImpl(socketManager: sl()),
  );

  // Repository
  sl.registerLazySingleton<SlotsRepository>(
    () => SlotsRepositoryImpl(
      remoteDataSource: sl(),
      socketDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSlotsUseCase(sl()));
  sl.registerLazySingleton(() => WatchSlotsUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => SlotsCubit(
      getSlotsUseCase: sl(),
      watchSlotsUseCase: sl(),
    ),
  );

  // Find Car Feature
  sl.registerLazySingleton<FindCarRemoteDataSource>(
    () => FindCarRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FindCarRepository>(
    () => FindCarRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => FindCarUseCase(sl()));
  sl.registerFactory(() => FindCarCubit(sl()));

  // Profile Feature
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // Home Feature
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(sl()));
  sl.registerFactory(() => HomeCubit(sl()));

  // ─────────────────────────────────────────────────────────────
  // Parking Overview Admin Feature
  // ─────────────────────────────────────────────────────────────

  // Data Sources
  // [ACTIVE] Mock — returns dummy data during development
  sl.registerLazySingleton<ParkingOverviewDataSource>(
    () => ParkingOverviewMockDataSourceImpl(),
  );

  // [SWAP WHEN BACKEND READY] Un-comment below & comment out mock above:
  // sl.registerLazySingleton<ParkingOverviewDataSource>(
  //   () => ParkingOverviewRemoteDataSourceImpl(apiClient: sl()),
  // );

  // Repository
  sl.registerLazySingleton<ParkingOverviewRepository>(
    () => ParkingOverviewRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetParkingOverviewUseCase(sl()));

  // Cubit
  sl.registerFactory(() => ParkingOverviewCubit(
        getParkingOverviewUseCase: sl(),
      ));
}
