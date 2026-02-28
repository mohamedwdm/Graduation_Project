import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent),

      body: SafeArea(child: HomeViewBody()),
      backgroundColor: Color(0xffF6F8F6),
    );
  }
}
