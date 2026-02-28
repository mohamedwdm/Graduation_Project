import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_cards.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_header_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        HomeHeaderSection(),
        HomeCards()
      ],),
    );
  }
}