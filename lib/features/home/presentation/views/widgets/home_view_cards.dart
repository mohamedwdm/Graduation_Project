import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_big_card.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_small_card.dart';
import 'package:go2car/features/layout/presentation/views/main_layout.dart';

class HomeViewCards extends StatelessWidget {
  const HomeViewCards({
    super.key,
    required this.availableSlots,
    required this.totalSlots,
    this.isGuest = false,
  });

  final int availableSlots;
  final int totalSlots;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeViewBigCard(
          onTap: () {
            context.findAncestorStateOfType<MainLayoutState>()?.changeTab(1);
          },
          availableSlots: availableSlots,
          totalSlots: totalSlots,
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isGuest)
              Expanded(
                child: HomeViewSmallCard(
                  onTap: () {
                    context.findAncestorStateOfType<MainLayoutState>()?.changeTab(2);
                  },
                  title: 'Find My Car',
                  subTitle: "Navigate back to your vehicle",
                  icon: Icons.place_outlined,
                  iconBackgroundColor: const Color(0xffF0FDF1),
                  iconColor: Colors.green,
                ),
              )
            else ...[
              HomeViewSmallCard(
                onTap: () {
                  context.findAncestorStateOfType<MainLayoutState>()?.changeTab(2);
                },
                title: 'Find My Car',
                subTitle: "Navigate back to your vehicle",
                icon: Icons.place_outlined,
                iconBackgroundColor: const Color(0xffF0FDF1),
                iconColor: Colors.green,
              ),
              HomeViewSmallCard(
                onTap: () {
                  context.push('/reserve-slot');
                },
                title: 'Reserve Slot',
                subTitle: 'Book your slot in advance',
                icon: Icons.bookmark_add_outlined,
                iconBackgroundColor: const Color(0xffEAFAF1),
                iconColor: const Color(0xff00A24F),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
