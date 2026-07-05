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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final welcomeColor = isDark ? Colors.white70 : const Color(0xff64748B);
    // final avatarBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xffEBEFF3);
    // final iconColor = isDark ? Colors.white70 : const Color(0xff94A3B8);
    // final notificationBorderColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textNameColor = isDark ? Colors.white : Colors.black;

    final isGuest = userName.toLowerCase() == 'guest' || userName.isEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              'Welcome back!',
              style: TextStyle(
                color: isGuest ? textNameColor : welcomeColor,
                fontSize: isGuest ? 24 : 14,
                fontWeight: isGuest ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (!isGuest) ...[
              const SizedBox(height: 4),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textNameColor,
                ),
              ),
            ],
          ],
        ),

        // Stack(
        //   children: [
        //     // Profile Circle
        //     CircleAvatar(
        //       radius: 23,
        //       backgroundColor: avatarBgColor,
        //       child: Icon(
        //         Icons.person_outline,
        //         size: 28,
        //         color: iconColor,
        //         weight: 900,
        //       ),
        //     ),
        //     if (hasNotification)
        //       Positioned(
        //         right: 0,
        //         bottom: 0,
        //         child: Container(
        //           width: 16,
        //           height: 16,
        //           decoration: BoxDecoration(
        //             color: const Color(0xff13EC5B),
        //             shape: BoxShape.circle,
        //             border: Border.all(color: notificationBorderColor, width: 2),
        //           ),
        //         ),
        //       ),
        //   ],
        // ),
      ],
    );
  }
}
