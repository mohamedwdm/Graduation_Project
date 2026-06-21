import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/saved_car_entity.dart';
import '../manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';

class SavedCarCard extends StatelessWidget {
  final SavedCarEntity car;

  const SavedCarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              color: Color(0xFF475569),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.model,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      car.plateNumber,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.43,
                      ),
                    ),
                    Text(
                      " - ${car.color}",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.near_me_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final response = await sl<ApiClient>().get(
                  ApiConstants.searchPlate,
                  queryParameters: {'plate': car.plateNumber},
                );

                if (context.mounted) {
                  Navigator.pop(context); // Pop loading dialog
                }

                if (response.data != null && response.data['data'] != null) {
                  final List dataList = response.data['data'] as List;
                  if (dataList.isNotEmpty) {
                    final firstCar = dataList.first;
                    final floor = firstCar['floor'] ?? '';
                    final section = firstCar['section'] ?? '';
                    final slot = firstCar['slot'] ?? '';
                    final location = '$floor, $section - Slot $slot';

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Navigating to $location...',
                            style: GoogleFonts.spaceGrotesk(),
                          ),
                          backgroundColor: const Color(0xFF1152D4),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      _showNotParkedDialog(context);
                    }
                  }
                } else {
                  if (context.mounted) {
                    _showNotParkedDialog(context);
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'This vehicle (${car.plateNumber}) is not currently detected in any parking slot.',
                        style: GoogleFonts.spaceGrotesk(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () async {
              await context.push(
                '/edit-saved-car',
                extra: car,
              );
              if (context.mounted) {
                context.read<SavedCarsCubit>().loadSavedCars();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showNotParkedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Car Not Parked',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'This vehicle (${car.plateNumber}) is not currently detected in any parking slot.',
          style: GoogleFonts.spaceGrotesk(
            color: const Color(0xFF475569),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF1152D4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
