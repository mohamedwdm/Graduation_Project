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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Find My Car",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.36,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: const SafeArea(
        child: _FindCarBody(),
      ),
    );
  }
}

class _FindCarBody extends StatefulWidget {
  const _FindCarBody();

  @override
  State<_FindCarBody> createState() => _FindCarBodyState();
}

class _FindCarBodyState extends State<_FindCarBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final closeBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final closeIconColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final headingColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: searchBgColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(9999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.search, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.spaceGrotesk(color: textColor, fontSize: 16),
                    onChanged: (query) => context.read<FindCarCubit>().searchCars(query),
                    decoration: InputDecoration(
                      hintText: "License plate, model, color...",
                      hintStyle: GoogleFonts.spaceGrotesk(
                        color: hintColor,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    context.read<FindCarCubit>().searchCars('');
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: closeBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 20, color: closeIconColor),
                  ),
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
              color: headingColor,
            ),
          ),
        ),
        // Car List
        Expanded(
          child: BlocBuilder<FindCarCubit, FindCarState>(
            builder: (context, state) {
              if (state is FindCarInitial) {
                final isDarkInit = Theme.of(context).brightness == Brightness.dark;
                final initHeadingColor = isDarkInit ? Colors.white : const Color(0xFF475569);
                final initSubColor = isDarkInit ? Colors.white70 : const Color(0xFF64748B);
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_outlined,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "Search by Plate Number or Vehicle attributes",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: initHeadingColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            "Enter a full or partial plate number or color or  Vehicle type to locate the vehicle's parking spot.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: initSubColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is FindCarLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff00A24F),
                  ),
                );
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
