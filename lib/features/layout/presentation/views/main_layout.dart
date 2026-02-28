import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/home_view.dart';
import 'package:go2car/features/slots/presentation/views/slots_view.dart';
import 'package:go2car/features/find_car/presentation/views/find_car_view.dart';
import 'package:go2car/features/profile/presentation/views/profile_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    SlotsView(),
    FindCarView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
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
       // backgroundColor: Color(0xffF9F9F9),
        backgroundColor: Color(0xffFFFFFF),
        
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking_outlined),
            label: "Slots",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: "Find Car",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}