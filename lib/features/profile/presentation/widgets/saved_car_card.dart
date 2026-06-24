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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final iconBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final modelColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final plateColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Container(
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              color: iconColor,
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
                    color: modelColor,
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
                        color: plateColor,
                        height: 1.43,
                      ),
                    ),
                    Text(
                      " - ${car.color}",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: plateColor,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.near_me_outlined,
              color: plateColor,
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
            icon: Icon(
              Icons.edit_outlined,
              color: plateColor,
              size: 20,
            ),
            onPressed: () async {
              final result = await context.push<bool>(
                '/edit-saved-car',
                extra: car,
              );
              if (result == true && context.mounted) {
                context.read<SavedCarsCubit>().loadSavedCars();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showNotParkedDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Car Not Parked',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'This vehicle (${car.plateNumber}) is not currently detected in any parking slot.',
          style: GoogleFonts.spaceGrotesk(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
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
