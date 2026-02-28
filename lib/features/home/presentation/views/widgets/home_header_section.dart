import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              'Welcome back!',
              style: TextStyle(color: Color(0xff64748B), fontSize: 14),
            ),
            //SizedBox(height: 5),
            Text(
              'Abdul Rahman',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xffEBEFF3),
          child: const Icon(
            Icons.person_outline,
            size: 26,
            color: Color(0xff94A3B8),
          ),
        ),
      ],
    );
  }
}
