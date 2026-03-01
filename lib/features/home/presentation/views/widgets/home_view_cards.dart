import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_big_card.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_small_card.dart';

class HomeViewCards extends StatelessWidget {
  const HomeViewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeViewBigCard(onTap: (){},),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeViewSmallCard(
              onTap: (){},
              title: 'Find My Car',
              subTitle: "Navigate back to your vehicle",
              icon: Icons.place_outlined,
              iconBackgroundColor: Color(0xffF0FDF1),
              iconColor: Colors.green,
            ),
            HomeViewSmallCard(
              onTap: (){},
              title: 'Settings & Profile',
              subTitle: 'Manage preferences',
              icon: Icons.settings_outlined,
              iconBackgroundColor: Color(0xffF8FAFC),
              iconColor: Color(0xff475569),
            ),
          ],
        ),
      ],
    );
  }
}

