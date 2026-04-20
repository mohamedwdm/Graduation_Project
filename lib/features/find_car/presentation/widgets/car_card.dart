import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/car_entity.dart';

class CarCard extends StatelessWidget {
  final CarEntity car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image Placeholder (80x80)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car,
                      color: Color(0xFF64748B),
                      size: 40,
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
                        car.model,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.plateNumber,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        car.color,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.parkingLocation,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: const Color(0xFF64748B),
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
            color: const Color(0xFFE2E8F0),
          ),
          // Action Buttons
          Row(
            children: [
              // View on Map
              Expanded(
                child: InkWell(
                  onTap: null, // Disabled
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF334155)),
                        const SizedBox(width: 8),
                        Text(
                          "View on map",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // vertical separator
              Container(width: 1, height: 52, color: const Color(0xFFE2E8F0)),
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
                        const Icon(Icons.navigation_outlined, size: 18, color: Color(0xFF13EC5B)),
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
