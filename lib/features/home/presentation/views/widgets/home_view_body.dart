import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:go2car/features/home/presentation/manager/home_cubit/home_state.dart';
import '../../../../../core/widgets/greeting_header.dart';
import 'home_view_cards.dart';
import 'quick_action_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        } else if (state is HomeLoaded) {
          final summary = state.summary;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingHeader(userName: summary.userName),
                const SizedBox(height: 20),
                HomeViewCards(
                  availableSlots: summary.availableSlots,
                  totalSlots: summary.totalSlots,
                ),
                const SizedBox(height: 25),
                Text(
                  "Quick Action",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                QuickActionCard(onTap: () {}),
              ],
            ),
          );
        }
        return const Center(child: Text("Initializing..."));
      },
    );
  }
}
