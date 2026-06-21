import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveMapSectionWidget extends StatelessWidget {
  final String mapImageUrl;

  const LiveMapSectionWidget({
    super.key,
    required this.mapImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = mapImageUrl.isEmpty ? 'assets/images/parking_map_placeholder.png' : mapImageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Map',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0F172A),
            letterSpacing: -0.27,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath.startsWith('assets/')
                ? Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/parking_map_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
