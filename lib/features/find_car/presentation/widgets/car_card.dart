import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/env_config.dart';
import '../../domain/entities/car_entity.dart';

class CarCard extends StatelessWidget {
  final CarEntity car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final imageBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final imageIconColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final modelTextColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final detailTextColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final buttonTextColor = isDark ? Colors.white70 : const Color(0xFF334155);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image with local/fallback placeholder (80x80)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: imageBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (car.imagePath != null && car.imagePath!.isNotEmpty)
                        ? Image.network(
                            car.imagePath!.startsWith('http')
                                ? car.imagePath!
                                : '${EnvConfig.instance.apiBaseUrl}/${car.imagePath!.replaceFirst(RegExp(r'^/'), '')}',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.directions_car,
                                  color: imageIconColor,
                                  size: 40,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF00A24F),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.directions_car,
                              color: imageIconColor,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Car Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.plateNumber,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.model,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: modelTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        car.color,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: detailTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.parkingLocation,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: detailTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Horizontal Border
          Container(
            height: 1,
            color: dividerColor,
          ),
          // Action Buttons
          Row(
            children: [
              // View on Map
              Expanded(
                child: InkWell(
                  onTap: null, // Disabled
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined,
                            size: 18, color: buttonTextColor),
                        const SizedBox(width: 8),
                        Text(
                          "View on map",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: buttonTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // vertical separator
              Container(width: 1, height: 52, color: dividerColor),
              // Navigate
              Expanded(
                child: InkWell(
                  onTap: null, // Disabled
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation_outlined,
                            size: 18, color: Color(0xFF13EC5B)),
                        const SizedBox(width: 8),
                        Text(
                          "Navigate",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: const Color(0xFF13EC5B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
