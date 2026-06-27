import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/layout/presentation/views/main_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/di/injection_container.dart';
import 'package:go2car/features/parking_overview_admin/presentation/manager/parking_overview_cubit/parking_overview_cubit.dart';
import 'package:go2car/features/parking_overview_admin/presentation/views/parking_overview_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/profile/presentation/views/add_saved_car_view.dart';
import '../../features/profile/presentation/views/edit_saved_car_view.dart';
import '../../features/profile/domain/entities/saved_car_entity.dart';
import '../../features/profile/presentation/manager/saved_car_form_cubit/saved_car_form_cubit.dart';
import '../../features/reservation/presentation/views/reserve_slot_view.dart';
import '../../features/reservation/presentation/views/booking_history_view.dart';
import '../../features/reservation/presentation/views/admin_reservations_view.dart';
import '../../features/reservation/presentation/manager/reservation_cubit/reservation_cubit.dart';
import '../../features/profile/presentation/manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../../features/slots/presentation/manager/slots_cubit/slots_cubit.dart';
import '../../features/profile/presentation/views/change_password_view.dart';

abstract class AppRouter {
  static const String loginPath = '/';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String adminParkingOverviewPath = '/admin/parking-overview';
  static const String adminReservationsPath = '/admin/reservations';
  static const String bookingHistoryPath = '/booking-history';
  static const String changePasswordPath = '/change-password';

  static final router = GoRouter(
    initialLocation: loginPath,
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: changePasswordPath,
        builder: (context, state) => const ChangePasswordView(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const Scaffold(
            body: Center(child: Text('Register View Placeholder'))),
      ),
      // GoRoute(
      //   path: homePath,
      //   builder: (context, state) => const Scaffold(body: Center(child: Text('Home View Placeholder'))),
      // ),
      GoRoute(
        path: homePath,
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return MainLayout(user: user);
        },
      ),
      GoRoute(
        path: adminParkingOverviewPath,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ParkingOverviewCubit>(),
          child: const ParkingOverviewView(),
        ),
      ),
      GoRoute(
        path: adminReservationsPath,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<ReservationCubit>()),
            BlocProvider(create: (context) => sl<SlotsCubit>()),
          ],
          child: const AdminReservationsView(),
        ),
      ),
      GoRoute(
        path: '/add-saved-car',
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SavedCarFormCubit>(),
          child: const AddSavedCarView(),
        ),
      ),
      GoRoute(
        path: '/edit-saved-car',
        builder: (context, state) {
          final car = state.extra as SavedCarEntity;
          return BlocProvider(
            create: (context) => sl<SavedCarFormCubit>(),
            child: EditSavedCarView(car: car),
          );
        },
      ),
      GoRoute(
        path: '/reserve-slot',
        builder: (context, state) {
          final slotCode = state.uri.queryParameters['slotCode'];
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ReservationCubit>()),
              BlocProvider(create: (context) => sl<SavedCarsCubit>()),
              BlocProvider(create: (context) => sl<SlotsCubit>()),
            ],
            child: ReserveSlotView(preselectedSlotCode: slotCode),
          );
        },
      ),
      GoRoute(
        path: bookingHistoryPath,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ReservationCubit>()),
              BlocProvider(create: (context) => sl<SlotsCubit>()),
            ],
            child: const BookingHistoryView(),
          );
        },
      ),
    ],
  );
}

