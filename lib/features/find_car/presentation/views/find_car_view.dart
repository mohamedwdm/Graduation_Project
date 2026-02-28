import 'package:flutter/material.dart';
import 'package:go2car/features/find_car/presentation/views/widgets/find_car_view_body.dart';

class FindCarView extends StatelessWidget {
  const FindCarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: FindCarViewBody()),
      backgroundColor: Color(0xffF6F8F6),
    );
  }
}
