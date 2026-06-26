import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_cubit.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_state.dart';
import '../manager/reservation_cubit/reservation_cubit.dart';
import '../manager/reservation_cubit/reservation_state.dart';

class BookingHistoryView extends StatefulWidget {
  const BookingHistoryView({super.key});

  @override
  State<BookingHistoryView> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView> {
  @override
  void initState() {
    super.initState();
    // Load reservations and slots definitions
    context.read<ReservationCubit>().getMyReservations();
    context.read<SlotsCubit>().loadSlots();
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
          'Booking History',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ReservationCubit, ReservationState>(
            listenWhen: (previous, current) =>
                current is CancelReservationSuccess || current is CancelReservationError,
            listener: (context, state) {
              if (state is CancelReservationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reservation cancelled successfully',
                      style: GoogleFonts.spaceGrotesk(),
                    ),
                    backgroundColor: const Color(0xFF00A24F),
                  ),
                );
                // Reload list of reservations
                context.read<ReservationCubit>().getMyReservations();
              } else if (state is CancelReservationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to cancel: ${state.message}',
                      style: GoogleFonts.spaceGrotesk(),
                    ),
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ReservationCubit, ReservationState>(
          buildWhen: (previous, current) =>
              current is MyReservationsLoading ||
              current is MyReservationsLoaded ||
              current is MyReservationsError,
          builder: (context, reservationState) {
            if (reservationState is MyReservationsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00A24F),
                ),
              );
            }

            if (reservationState is MyReservationsError) {
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
                        onPressed: () => context.read<ReservationCubit>().getMyReservations(),
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

            if (reservationState is MyReservationsLoaded) {
              final reservations = reservationState.reservations;

              if (reservations.isEmpty) {
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
                        const SizedBox(height: 8),
                        Text(
                          'You haven\'t made any bookings yet.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceGrotesk(
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return BlocBuilder<SlotsCubit, SlotsState>(
                builder: (context, slotsState) {
                  // Create a mapping of slot ID to SlotEntity for easy lookup
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

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final res = reservations[index];
                      final slotLabel = slotCodeMap[res.slotId] ?? 'Slot #${res.slotId}';
                      final location = slotLocationMap[res.slotId] ?? '';
                      final isCancellable = res.status.toLowerCase() == 'pending' ||
                          res.status.toLowerCase() == 'active';

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
                              // Card Header
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: borderColor),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_parking,
                                      color: const Color(0xFF00A24F),
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
                                    if (res.vehicleId != null) ...[
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.directions_car_outlined, size: 16, color: subtitleColor),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Vehicle ID: #${res.vehicleId}',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 13,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Card Footer / Cancel Action
                              if (isCancellable)
                                BlocBuilder<ReservationCubit, ReservationState>(
                                  builder: (context, cancelState) {
                                    final isLoading = cancelState is CancelReservationLoading;

                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: borderColor),
                                        ),
                                      ),
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          foregroundColor: const Color(0xFFEF4444),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () => _confirmCancel(context, res.id),
                                        icon: isLoading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFFEF4444),
                                                ),
                                              )
                                            : const Icon(Icons.cancel_outlined, size: 18),
                                        label: Text(
                                          'Cancel Reservation',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
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

  void _confirmCancel(BuildContext context, int reservationId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Cancel Booking',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to cancel this reservation?',
            style: GoogleFonts.spaceGrotesk(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'No, Keep It',
                style: GoogleFonts.spaceGrotesk(color: const Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ReservationCubit>().cancelReservation(reservationId);
              },
              child: Text(
                'Yes, Cancel',
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
