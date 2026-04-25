import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../manager/saved_cars_cubit/saved_cars_state.dart';
import 'saved_car_card.dart';

class SavedCarsSection extends StatelessWidget {
  const SavedCarsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Cars',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.27,
                ),
              ),
              InkWell(
                onTap: () async {
                  await context.push('/add-saved-car');
                  if (context.mounted) {
                    context.read<SavedCarsCubit>().loadSavedCars();
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF13EC5B),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add New',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF13EC5B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<SavedCarsCubit, SavedCarsState>(
          builder: (context, state) {
            if (state is SavedCarsLoading) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF13EC5B)),
              ));
            } else if (state is SavedCarsEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No cars saved yet',
                    style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
                  ),
                ),
              );
            } else if (state is SavedCarsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    style: GoogleFonts.spaceGrotesk(color: Colors.red),
                  ),
                ),
              );
            } else if (state is SavedCarsLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.cars.length,
                itemBuilder: (context, index) {
                  return SavedCarCard(car: state.cars[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
