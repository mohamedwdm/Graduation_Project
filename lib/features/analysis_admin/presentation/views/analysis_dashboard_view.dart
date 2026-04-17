import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go2car/core/config/app_router.dart';
import 'package:go_router/go_router.dart';
import '../manager/analysis_cubit/analysis_cubit.dart';
import '../widgets/occupancy_donut_chart.dart';
import '../widgets/traffic_flow_card.dart';
import '../widgets/analysis_status_bar_widget.dart';

class AnalysisDashboardView extends StatefulWidget {
  const AnalysisDashboardView({super.key});

  @override
  State<AnalysisDashboardView> createState() => _AnalysisDashboardViewState();
}

class _AnalysisDashboardViewState extends State<AnalysisDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<AnalysisCubit>().loadAnalysisData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xff1152D4),
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xff1152D4).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff1152D4).withOpacity(0.2)),
              ),
              child: const Icon(Icons.person_outline, size: 18, color: Color(0xff1152D4)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisForbidden) {
            context.go(AppRouter.homePath);
          }
        },
        builder: (context, state) {
          if (state is AnalysisLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalysisError) {
            return Center(child: Text(state.message));
          }

          if (state is AnalysisLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () => context.read<AnalysisCubit>().loadAnalysisData(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Date Filter Button (Stylized)
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xff1152D4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.calendar_today_outlined,
                              size: 20, color: Color(0xff1152D4)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ANALYSIS PERIOD',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff64748B),
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Today, 12:00 PM - Now',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff0D121B),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.tune, color: Color(0xff64748B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Real-time Occupancy Section
                  _buildSectionHeader('Real-time Occupancy', 'Main Parking Lot'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        OccupancyDonutChart(percent: data.occupancyPercent),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildMetricRow('Occupied', data.occupiedCount, const Color(0xff1152D4)),
                              const SizedBox(height: 16),
                              _buildMetricRow('Free', data.freeCount, const Color(0xffE5E7EB)),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(height: 1, color: Color(0xffF3F4F6)),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total Capacity',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: const Color(0xff64748B),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${data.totalCapacity}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff0D121B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Traffic Flow Section
                  _buildSectionHeader('Traffic Flow', 'Overall Movements'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TrafficFlowCard(
                          title: 'Cars Parked',
                          count: data.carsParkedTotal.toString(),
                          trend: '+${(data.carsParkedChange * 100).toInt()}%',
                          icon: Icons.login,
                          iconBackgroundColor: const Color(0xff1152D4).withOpacity(0.1),
                          iconColor: const Color(0xff1152D4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TrafficFlowCard(
                          title: 'Cars Left',
                          count: data.carsLeftTotal.toString(),
                          trend: '+${(data.carsLeftChange * 100).toInt()}%',
                          icon: Icons.logout,
                          iconBackgroundColor: const Color(0xffFFEDD5),
                          iconColor: const Color(0xffEA580C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Camera Status Section
                  _buildSectionHeader('Camera Status', 'Internal & External Network'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AnalysisStatusBarWidget(
                          label: 'Online Cameras',
                          count: data.onlineCameras,
                          progress: data.onlineCameras / (data.onlineCameras + data.offlineCameras),
                          activeColor: const Color(0xff10B981),
                          shadowColor: const Color(0xff10B981).withOpacity(0.5),
                        ),
                        const SizedBox(height: 24),
                        AnalysisStatusBarWidget(
                          label: 'Offline Cameras',
                          count: data.offlineCameras,
                          progress: data.offlineCameras / (data.onlineCameras + data.offlineCameras),
                          activeColor: const Color(0xffEF4444),
                          shadowColor: const Color(0xffEF4444).withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xff0D121B),
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xff64748B),
          ),
        ),
        const Spacer(),
        Text(
          '$count',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xff0D121B),
          ),
        ),
      ],
    );
  }
}
