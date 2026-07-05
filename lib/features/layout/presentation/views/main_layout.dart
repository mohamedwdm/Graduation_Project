import 'package:flutter/material.dart';
import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:go2car/features/home/presentation/views/home_view.dart';
import 'package:go2car/features/slots/presentation/views/slots_view.dart';
import 'package:go2car/features/find_car/presentation/views/find_car_view.dart';
import 'package:go2car/features/profile/presentation/views/profile_view.dart';
import 'package:go2car/features/parking_overview_admin/presentation/views/parking_overview_view.dart';
import 'package:go2car/features/parking_overview_admin/presentation/manager/parking_overview_cubit/parking_overview_cubit.dart';
import 'package:go2car/features/analysis_admin/presentation/views/analysis_dashboard_view.dart';
import 'package:go2car/features/analysis_admin/presentation/manager/analysis_cubit/analysis_cubit.dart';
import 'package:go2car/features/manage_slots_admin/presentation/views/manage_slots_view.dart';
import 'package:go2car/features/manage_slots_admin/presentation/manager/manage_slots_cubit/manage_slots_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/features/find_car/presentation/manager/find_car_cubit/find_car_cubit.dart';
import 'package:go2car/features/profile/presentation/manager/saved_cars_cubit/saved_cars_cubit.dart';
import 'package:go2car/features/profile/presentation/manager/saved_cars_cubit/saved_cars_state.dart';
import 'package:go2car/core/di/injection_container.dart';

class MainLayout extends StatefulWidget {
  final UserEntity? user;
  const MainLayout({super.key, this.user});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  
  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  UserEntity? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    if (_currentUser == null) {
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await sl<AuthLocalDataSource>().getCachedUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xff00A24F),
          ),
        ),
      );
    }

    final user = _currentUser;
    final List<Widget> pages = [];
    final List<BottomNavigationBarItem> items = [];

    if (user?.isAdmin ?? false) {
      pages.addAll([
       // const SlotsView(),
        const FindCarView(),
        BlocProvider(
          create: (context) => sl<ParkingOverviewCubit>(),
          child: const ParkingOverviewView(),
        ),
        BlocProvider(
          create: (context) => sl<AnalysisCubit>(),
          child: const AnalysisDashboardView(),
        ),
        BlocProvider(
          create: (context) => sl<ManageSlotsCubit>(),
          child: const ManageSlotsView(),
        ), 
        const ProfileView(isAdmin: true),
      ]);

      items.addAll([
        // const BottomNavigationBarItem(
        //   icon: Icon(Icons.local_parking_outlined),
        //   label: "Slots",
        // ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          label: "Find Car",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Overview",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Analyze",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_suggest_outlined),
          label: "Manage",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ]);
    } else if (user?.isGuest ?? false) {
      pages.addAll([
        const HomeView(isGuest: true),
        const SlotsView(),
        const FindCarView(),
        const ProfileView(isAdmin: false),
      ]);

      items.addAll([
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_parking_outlined),
          label: "Slots",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          label: "Find Car",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ]);
    } else {
      pages.addAll([
        const HomeView(),
        const SlotsView(),
        const FindCarView(),
        const ProfileView(isAdmin: false),
      ]);

      items.addAll([
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_parking_outlined),
          label: "Slots",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          label: "Find Car",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ]);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
    final unselectedColor = isDark ? Colors.white60 : Colors.grey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.2,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xff00A24F),
        unselectedItemColor: unselectedColor,
        showUnselectedLabels: true,
        backgroundColor: navBgColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          // Guest now has 4 tabs (Home=0, Slots=1, FindCar=2, Profile=3)
          // Regular user also has 4 tabs (Home=0, Slots=1, FindCar=2, Profile=3)
          final isProfileTab = index == 3;
          if (isProfileTab && !(user?.isAdmin ?? false) && !(user?.isGuest ?? false)) {
            final savedCarsCubit = context.read<SavedCarsCubit>();
            if (savedCarsCubit.state is SavedCarsInitial || savedCarsCubit.state is SavedCarsError) {
              savedCarsCubit.loadSavedCars();
            }
          }
        },
        items: items,
      ),
    );
  }
}