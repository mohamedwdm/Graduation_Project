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
    return Scaffold(
      backgroundColor: const Color(0xffF6F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F8F6),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Parking Overview',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xffE2E8F0),
              child: const Icon(
                Icons.notifications_none_outlined,
                color: Color(0xff0F172A),
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
                        backgroundColor: const Color(0xffF1F5F9),
                        borderColor: const Color(0xffE2E8F0),
                        titleColor: const Color(0xff475569),
                      ),
                      StatCardWidget(
                        title: 'Free Slots',
                        value: overview.freeSlots.toString(),
                        backgroundColor: const Color(0xff22C55E).withOpacity(0.1),
                        borderColor: const Color(0xff22C55E).withOpacity(0.2),
                        titleColor: const Color(0xff166534),
                      ),
                      StatCardWidget(
                        title: 'Occupied Slots',
                        value: overview.occupiedSlots.toString(),
                        backgroundColor: const Color(0xffEF4444).withOpacity(0.1),
                        borderColor: const Color(0xffEF4444).withOpacity(0.2),
                        titleColor: const Color(0xff991B1B),
                      ),
                      StatCardWidget(
                        title: 'Cameras',
                        value: overview.cameraCount.toString(),
                        backgroundColor: const Color(0xffF1F5F9),
                        borderColor: const Color(0xffE2E8F0),
                        titleColor: const Color(0xff475569),
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
