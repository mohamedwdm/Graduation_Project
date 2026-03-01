import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_view_cards.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_header_section.dart';
import 'package:go2car/features/home/presentation/views/widgets/quick_action_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeaderSection(),
          SizedBox(height: 20),
          HomeViewCards(),
          SizedBox(height: 25),
          Text(
            "Quick Action",
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 15),
          QuickActionCard(onTap: () {}),
        ],
      ),
    );
  }
}
