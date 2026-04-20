import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/find_car_cubit/find_car_cubit.dart';
import '../manager/find_car_cubit/find_car_state.dart';
import '../widgets/car_card.dart';

class FindCarView extends StatelessWidget {
  const FindCarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FindCarCubit>()..getUserCars(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          title: Text(
            "Find My Car",
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: -0.36,
              color: const Color(0xFF0F172A),
            ),
          ),
          backgroundColor: const Color(0xFFF6F8F6),
          elevation: 0,
          centerTitle: false,
        ),
        body: const SafeArea(
          child: _FindCarBody(),
        ),
      ),
    );
  }
}

class _FindCarBody extends StatelessWidget {
  const _FindCarBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(9999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF64748B), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (query) => context.read<FindCarCubit>().getUserCars(), // simplified for now
                    decoration: InputDecoration(
                      hintText: "License plate, model, color...",
                      hintStyle: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF64748B),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ),
        // Heading "RESULTS"
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 12.0),
          child: Text(
            "RESULTS",
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.7,
              color: const Color(0xFF475569),
            ),
          ),
        ),
        // Car List
        Expanded(
          child: BlocBuilder<FindCarCubit, FindCarState>(
            builder: (context, state) {
              if (state is FindCarLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FindCarError) {
                return Center(child: Text(state.message));
              }
              if (state is FindCarLoaded) {
                if (state.cars.isEmpty) {
                  return const Center(child: Text("No cars found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: state.cars.length,
                  itemBuilder: (context, index) {
                    return CarCard(car: state.cars[index]);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
