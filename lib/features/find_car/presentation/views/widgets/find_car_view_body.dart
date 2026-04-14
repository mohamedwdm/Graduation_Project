import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/features/find_car/presentation/manager/find_car_cubit/find_car_cubit.dart';
import 'package:go2car/features/find_car/presentation/manager/find_car_cubit/find_car_state.dart';
import 'package:google_fonts/google_fonts.dart';

class FindCarViewBody extends StatelessWidget {
  const FindCarViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindCarCubit, FindCarState>(
      builder: (context, state) {
        if (state is FindCarLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FindCarError) {
          return Center(child: Text(state.message));
        } else if (state is FindCarLoaded) {
          final car = state.carLocation;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find My Car",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We found your car parked in",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLocationInfo("Floor", car.floor.toString(), Icons.layers),
                          _buildLocationInfo("Section", car.section, Icons.grid_view),
                          _buildLocationInfo("Slot", car.slotLabel, Icons.local_parking),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF64748B), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Parked at: ",
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatParkedTime(car.parkedAt),
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (car.estimatedWalkTime != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A24F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF00A24F).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_walk, color: Color(0xFF00A24F)),
                        const SizedBox(width: 12),
                        Text(
                          "Estimated walk time: ${car.estimatedWalkTime!.inMinutes} mins",
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF00A24F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic to show directions
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A24F),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Get Directions",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text("Initializing..."));
      },
    );
  }

  Widget _buildLocationInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00A24F), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  String _formatParkedTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}