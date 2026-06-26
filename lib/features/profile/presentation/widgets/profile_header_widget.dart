import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final emailTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final avatarBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final avatarIconColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    // final cameraBorderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF6F8F6);

    return Column(
      children: [
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: avatarBgColor,
              ),
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? Icon(Icons.person, size: 48, color: avatarIconColor)
                  : null,
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: InkWell(
            //     onTap: () => _showPicker(context),
            //     child: Container(
            //       width: 32,
            //       height: 32,
            //       decoration: BoxDecoration(
            //         color: const Color(0xFF1E293B),
            //         shape: BoxShape.circle,
            //         border: Border.all(color: cameraBorderColor, width: 2),
            //       ),
            //       child: const Icon(
            //         Icons.camera_alt_outlined,
            //         color: Colors.white,
            //         size: 16,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: nameTextColor,
            height: 1.56,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          email,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: emailTextColor,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // void _showPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext bc) {
  //       final isDarkSheet = Theme.of(context).brightness == Brightness.dark;
  //       final sheetIconColor = isDarkSheet ? Colors.white70 : const Color(0xFF1E293B);
  //       final sheetTextColor = isDarkSheet ? Colors.white : const Color(0xFF1E293B);
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                 leading: Icon(Icons.photo_library_outlined, color: sheetIconColor),
  //                 title: Text('Gallery', style: GoogleFonts.spaceGrotesk(color: sheetTextColor, fontWeight: FontWeight.w500)),
  //                 onTap: () => Navigator.of(context).pop(),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.photo_camera_outlined, color: sheetIconColor),
  //                 title: Text('Camera', style: GoogleFonts.spaceGrotesk(color: sheetTextColor, fontWeight: FontWeight.w500)),
  //                 onTap: () => Navigator.of(context).pop(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
