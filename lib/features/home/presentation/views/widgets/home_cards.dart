import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/small_button.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.22,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_button_image.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "P",
                      style: TextStyle(
                        color: Color(0xff13E659),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff13E659),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "AI Powered",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "Find Available Slot",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Locate the nearest parking spot instantly",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
            ],
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmallCard(
              title: 'Find My Car',
              subTitle: "Navigate back to your vehicle",
              icon: Icons.place_outlined,
              iconBackgroundColor: Color(0xffF0FDF1),
              iconColor: Colors.green,
            ),
            SmallCard(
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
