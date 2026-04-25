import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/saved_car_entity.dart';
import '../manager/saved_cars_cubit/saved_cars_cubit.dart';

class SavedCarCard extends StatelessWidget {
  final SavedCarEntity car;

  const SavedCarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
                Text(
                  car.plateNumber,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.43,
                  ),
                ),
              ],
            ),
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
}
