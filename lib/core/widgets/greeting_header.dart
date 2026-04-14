import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    this.hasNotification = true,
    required this.userName,
  });

  final bool hasNotification;
  final String userName;
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
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        Stack(
          children: [
            // Profile Circle
            CircleAvatar(
              radius: 23,
              backgroundColor: Color(0xffEBEFF3),
              child: Icon(
                Icons.person_outline,
                size: 28,
                color: Color(0xff94A3B8),
                weight: 900,
              ),
            ),
            if (hasNotification)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Color(0xff13EC5B),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        // CircleAvatar(
        //   radius: 24,
        //   backgroundColor: Color(0xffEBEFF3),
        //   child: const Icon(
        //     Icons.person_outline,
        //     size: 26,
        //     color: Color(0xff94A3B8),
        //   ),
        // ),
      ],
    );
  }
}
