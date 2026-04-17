import 'package:flutter/material.dart';
import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/home/presentation/views/home_view.dart';
import 'package:go2car/features/slots/presentation/views/slots_view.dart';
import 'package:go2car/features/find_car/presentation/views/find_car_view.dart';
import 'package:go2car/features/profile/presentation/views/profile_view.dart';
import 'package:go2car/features/parking_overview_admin/presentation/views/parking_overview_view.dart';
import 'package:go2car/features/parking_overview_admin/presentation/manager/parking_overview_cubit/parking_overview_cubit.dart';
import 'package:go2car/features/analysis_admin/presentation/views/analysis_dashboard_view.dart';
import 'package:go2car/features/analysis_admin/presentation/manager/analysis_cubit/analysis_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/di/injection_container.dart';

class MainLayout extends StatefulWidget {
  final UserEntity? user;
  const MainLayout({super.key, this.user});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const SlotsView(),
      const FindCarView(),
    ];

    final List<BottomNavigationBarItem> items = [
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
    ];

    if (widget.user?.isAdmin ?? false) {
      pages.add(
        BlocProvider(
          create: (context) => sl<ParkingOverviewCubit>(),
          child: const ParkingOverviewView(),
        ),
      );
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Overview",
        ),
      );
      
      pages.add(
        BlocProvider(
          create: (context) => sl<AnalysisCubit>(),
          child: const AnalysisDashboardView(),
        ),
      );
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Analyze",
        ),
      );
    } else {
      pages.add(const ProfileView());
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.2,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xff00A24F),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: const Color(0xffFFFFFF),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: items,
      ),
    );
  }
}