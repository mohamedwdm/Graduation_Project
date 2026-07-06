import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go2car/core/config/app_router.dart';
import 'package:go_router/go_router.dart';
import '../manager/parking_overview_cubit/parking_overview_cubit.dart';
import '../manager/parking_overview_cubit/parking_overview_state.dart';
import '../widgets/activity_log_section_widget.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  bool _showOnlyFlagged = false;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    context.read<AdminNotificationsCubit>().loadOverview(onlyFlagged: _showOnlyFlagged);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final appBarBg = isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final titleColor = isDark ? Colors.white : const Color(0xff0F172A);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifications',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : const Color(0xff64748B),
                  ),
                ),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(
                        'All Logs',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !_showOnlyFlagged
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xff0f172a)),
                        ),
                      ),
                      selected: !_showOnlyFlagged,
                      selectedColor: const Color(0xff00A24F),
                      backgroundColor: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _showOnlyFlagged = false;
                            _loadLogs();
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(
                        'Violations',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _showOnlyFlagged
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xff0f172a)),
                        ),
                      ),
                      selected: _showOnlyFlagged,
                      selectedColor: Colors.redAccent,
                      backgroundColor: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _showOnlyFlagged = true;
                            _loadLogs();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<AdminNotificationsCubit, AdminNotificationsState>(
                listener: (context, state) {
                  if (state is AdminNotificationsForbidden) {
                    context.go(AppRouter.homePath);
                  }
                },
                builder: (context, state) {
                  if (state is AdminNotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminNotificationsError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is AdminNotificationsLoaded) {
                    final overview = state.overview;
                    return RefreshIndicator(
                      color: const Color(0xff00A24F),
                      onRefresh: () async => _loadLogs(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ActivityLogSectionWidget(activities: overview.activityLog),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
