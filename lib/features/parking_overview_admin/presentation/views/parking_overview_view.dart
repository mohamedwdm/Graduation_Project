import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go2car/core/config/app_router.dart';
import 'package:go_router/go_router.dart';
import '../manager/parking_overview_cubit/parking_overview_cubit.dart';
import '../manager/parking_overview_cubit/parking_overview_state.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/live_map_section_widget.dart';
import '../widgets/activity_log_section_widget.dart';

class ParkingOverviewView extends StatefulWidget {
  const ParkingOverviewView({super.key});

  @override
  State<ParkingOverviewView> createState() => _ParkingOverviewViewState();
}

class _ParkingOverviewViewState extends State<ParkingOverviewView> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingOverviewCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final appBarBg = isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final titleColor = isDark ? Colors.white : const Color(0xff0F172A);
    final avatarBg = isDark ? const Color(0xff1E293B) : const Color(0xffE2E8F0);
    final iconColor = isDark ? Colors.white70 : const Color(0xff0F172A);

    // Card Colors
    final defaultCardBg = isDark ? const Color(0xff1E293B) : const Color(0xffF1F5F9);
    final defaultCardBorder = isDark ? const Color(0xff334155) : const Color(0xffE2E8F0);
    final defaultCardTitle = isDark ? const Color(0xff94A3B8) : const Color(0xff475569);

    final greenCardBg = const Color(0xff22C55E).withOpacity(isDark ? 0.15 : 0.1);
    final greenCardBorder = const Color(0xff22C55E).withOpacity(isDark ? 0.3 : 0.2);
    final greenCardTitle = isDark ? const Color(0xff4ADE80) : const Color(0xff166534);

    final redCardBg = const Color(0xffEF4444).withOpacity(isDark ? 0.15 : 0.1);
    final redCardBorder = const Color(0xffEF4444).withOpacity(isDark ? 0.3 : 0.2);
    final redCardTitle = isDark ? const Color(0xffF87171) : const Color(0xff991B1B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Parking Overview',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.book_online_outlined, color: iconColor),
            tooltip: 'Manage Bookings',
            onPressed: () => context.push(AppRouter.adminReservationsPath),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: avatarBg,
              child: Icon(
                Icons.notifications_none_outlined,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ParkingOverviewCubit, ParkingOverviewState>(
        listener: (context, state) {
          if (state is ParkingOverviewForbidden) {
            context.go(AppRouter.homePath);
          }
        },
        builder: (context, state) {
          if (state is ParkingOverviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ParkingOverviewError) {
            return Center(child: Text(state.message));
          }

          if (state is ParkingOverviewLoaded) {
            final overview = state.overview;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      StatCardWidget(
                        title: 'Total Slots',
                        value: overview.totalSlots.toString(),
                        backgroundColor: defaultCardBg,
                        borderColor: defaultCardBorder,
                        titleColor: defaultCardTitle,
                      ),
                      StatCardWidget(
                        title: 'Free Slots',
                        value: overview.freeSlots.toString(),
                        backgroundColor: greenCardBg,
                        borderColor: greenCardBorder,
                        titleColor: greenCardTitle,
                      ),
                      StatCardWidget(
                        title: 'Occupied Slots',
                        value: overview.occupiedSlots.toString(),
                        backgroundColor: redCardBg,
                        borderColor: redCardBorder,
                        titleColor: redCardTitle,
                      ),
                      StatCardWidget(
                        title: 'Cameras',
                        value: overview.cameraCount.toString(),
                        backgroundColor: defaultCardBg,
                        borderColor: defaultCardBorder,
                        titleColor: defaultCardTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  LiveMapSectionWidget(mapImageUrl: overview.mapImageUrl),
                  const SizedBox(height: 24),
                  ActivityLogSectionWidget(activities: overview.activityLog),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
