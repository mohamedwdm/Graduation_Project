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
  @override
  void initState() {
    super.initState();
    context.read<AdminNotificationsCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final appBarBg = isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final titleColor = isDark ? Colors.white : const Color(0xff0F172A);
    // final avatarBg = isDark ? const Color(0xff1E293B) : const Color(0xffE2E8F0);
    // final iconColor = isDark ? Colors.white70 : const Color(0xff0F172A);

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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.book_online_outlined, color: iconColor),
        //     tooltip: 'Manage Bookings',
        //     onPressed: () => context.push(AppRouter.adminReservationsPath),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: CircleAvatar(
        //       radius: 20,
        //       backgroundColor: avatarBg,
        //       child: Icon(
        //         Icons.notifications_none_outlined,
        //         color: iconColor,
        //         size: 24,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: BlocConsumer<AdminNotificationsCubit, AdminNotificationsState>(
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
