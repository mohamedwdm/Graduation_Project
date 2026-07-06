import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_cubit.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_state.dart';
import '../manager/reservation_cubit/reservation_cubit.dart';
import '../manager/reservation_cubit/reservation_state.dart';

class AdminReservationsView extends StatefulWidget {
  const AdminReservationsView({super.key});

  @override
  State<AdminReservationsView> createState() => _AdminReservationsViewState();
}

class _AdminReservationsViewState extends State<AdminReservationsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch all reservations & slot descriptions
    context.read<ReservationCubit>().getAllReservations();
    context.read<SlotsCubit>().loadSlots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} $hour:$minute $amPm';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF00A24F); // Green
      case 'pending':
        return const Color(0xFFE2A000); // Orange/Yellow
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEF4444); // Red
      case 'completed':
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF64748B); // Slate
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Bookings',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF00A24F),
          unselectedLabelColor: subtitleColor,
          indicatorColor: const Color(0xFF00A24F),
          labelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'ALL'),
            Tab(text: 'PENDING'),
            Tab(text: 'ACTIVE'),
          ],
        ),
      ),
      body: BlocListener<ReservationCubit, ReservationState>(
        listenWhen: (previous, current) =>
            current is ApproveReservationSuccess ||
            current is ApproveReservationError ||
            current is RejectReservationSuccess ||
            current is RejectReservationError,
        listener: (context, state) {
          if (state is ApproveReservationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Reservation for ${state.reservation.plateNumber ?? 'Vehicle'} approved and checked-in successfully!',
                  style: GoogleFonts.spaceGrotesk(),
                ),
                backgroundColor: const Color(0xFF00A24F),
              ),
            );
            // Reload all reservations
            context.read<ReservationCubit>().getAllReservations();
          } else if (state is ApproveReservationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to approve: ${state.message}',
                  style: GoogleFonts.spaceGrotesk(),
                ),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          } else if (state is RejectReservationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Reservation for ${state.reservation.plateNumber ?? 'Vehicle'} rejected successfully!',
                  style: GoogleFonts.spaceGrotesk(),
                ),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
            // Reload all reservations
            context.read<ReservationCubit>().getAllReservations();
          } else if (state is RejectReservationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to reject: ${state.message}',
                  style: GoogleFonts.spaceGrotesk(),
                ),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          }
        },
        child: BlocBuilder<ReservationCubit, ReservationState>(
          buildWhen: (previous, current) =>
              current is AllReservationsLoading ||
              current is AllReservationsLoaded ||
              current is AllReservationsError,
          builder: (context, reservationState) {
            if (reservationState is AllReservationsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00A24F),
                ),
              );
            }

            if (reservationState is AllReservationsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: const Color(0xFFEF4444)),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load reservations',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reservationState.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A24F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => context.read<ReservationCubit>().getAllReservations(),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (reservationState is AllReservationsLoaded) {
              final allReservations = reservationState.reservations;

              return BlocBuilder<SlotsCubit, SlotsState>(
                builder: (context, slotsState) {
                  // Create mappings of slot ID to Slot details
                  final Map<int, String> slotCodeMap = {};
                  final Map<int, String> slotLocationMap = {};

                  if (slotsState is SlotsLoaded) {
                    for (var slot in slotsState.slots) {
                      final idInt = int.tryParse(slot.id);
                      if (idInt != null) {
                        slotCodeMap[idInt] = slot.label;
                        slotLocationMap[idInt] = 'Floor ${slot.floor}, Section ${slot.section}';
                      }
                    }
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // ALL TAB (Active & Pending only)
                      _buildReservationList(
                        allReservations
                            .where((r) =>
                                r.status.toLowerCase() == 'active' ||
                                r.status.toLowerCase() == 'pending')
                            .toList(),
                        slotCodeMap,
                        slotLocationMap,
                        cardColor,
                        borderColor,
                        textColor,
                        subtitleColor,
                        dividerColor,
                        isDark,
                      ),
                      // PENDING TAB
                      _buildReservationList(
                        allReservations.where((r) => r.status.toLowerCase() == 'pending').toList(),
                        slotCodeMap,
                        slotLocationMap,
                        cardColor,
                        borderColor,
                        textColor,
                        subtitleColor,
                        dividerColor,
                        isDark,
                      ),
                      // ACTIVE TAB
                      _buildReservationList(
                        allReservations.where((r) => r.status.toLowerCase() == 'active').toList(),
                        slotCodeMap,
                        slotLocationMap,
                        cardColor,
                        borderColor,
                        textColor,
                        subtitleColor,
                        dividerColor,
                        isDark,
                      ),
                    ],
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildReservationList(
    List<dynamic> list,
    Map<int, String> slotCodeMap,
    Map<int, String> slotLocationMap,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color subtitleColor,
    Color dividerColor,
    bool isDark,
  ) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'No reservations found',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final res = list[index];
        final slotLabel = res.slotCode ?? slotCodeMap[res.slotId] ?? 'Slot #${res.slotId}';
        final location = slotLocationMap[res.slotId] ?? '';
        final isPending = res.status.toLowerCase() == 'pending';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_parking,
                        color: Color(0xFF00A24F),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        slotLabel,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(res.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(res.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          res.status.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _getStatusColor(res.status),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Card Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (location.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: subtitleColor),
                            const SizedBox(width: 8),
                            Text(
                              location,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time, size: 16, color: subtitleColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From: ${_formatDateTime(res.startTime)}',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    color: subtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'To: ${_formatDateTime(res.endTime)}',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // User Info
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 16, color: subtitleColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              res.userName != null && res.userName!.isNotEmpty
                                  ? '${res.userName} (${res.userEmail})'
                                  : 'User ID: #${res.userId}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Vehicle / Plate Info
                      Row(
                        children: [
                          Icon(Icons.directions_car_outlined, size: 16, color: subtitleColor),
                          const SizedBox(width: 8),
                          Text(
                            res.plateNumber != null && res.plateNumber!.isNotEmpty
                                ? 'Plate Number: ${res.plateNumber}'
                                : 'Vehicle ID: #${res.vehicleId}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              color: subtitleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions (Approve / Check In)
                if (isPending) ...[
                  Divider(height: 1, color: dividerColor),
                  Container(
                    width: double.infinity,
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    child: Row(
                      children: [
                        // Reject Button
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: const Color(0xFFEF4444),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            onPressed: () => _confirmReject(context, res.id, res.plateNumber ?? 'Vehicle'),
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: Text(
                              'Reject',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: dividerColor,
                        ),
                        // Approve Button
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: const Color(0xFF00A24F),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                            ),
                            onPressed: () => _confirmApprove(context, res.id, res.plateNumber ?? 'Vehicle'),
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            label: Text(
                              'Approve',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmApprove(BuildContext dialogContext, int reservationId, String plate) {
    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Approve Reservation',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to approve the reservation for vehicle "$plate" and check it in to the parking slot? This will mark the slot as occupied and create an active parking session.',
            style: GoogleFonts.spaceGrotesk(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogContext.read<ReservationCubit>().approveReservation(reservationId);
              },
              child: Text(
                'Yes, Approve',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF00A24F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmReject(BuildContext dialogContext, int reservationId, String plate) {
    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Reject Reservation',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to reject the reservation for vehicle "$plate"? This will cancel the booking.',
            style: GoogleFonts.spaceGrotesk(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogContext.read<ReservationCubit>().rejectReservation(reservationId);
              },
              child: Text(
                'Yes, Reject',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

