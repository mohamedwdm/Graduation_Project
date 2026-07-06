import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/slot_entity.dart';
import '../manager/manage_slots_cubit/manage_slots_cubit.dart';
import '../../../find_car/domain/entities/car_entity.dart';
import '../../../find_car/presentation/widgets/vehicle_map_dialog.dart';

class SlotCardWidget extends StatelessWidget {
  final SlotEntity slot;

  const SlotCardWidget({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final shadowColor =
        isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.05);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF0F172A);

    // final navigateBtnBgColor = isDark ? const Color(0xFF334155) : const Color(0xff0F172A);
    // final navigateBtnTextColor = Colors.white;

    final viewMapBtnBgColor =
        isDark ? const Color(0xFF334155) : const Color(0xffE2E8F0);
    final viewMapBtnTextColor = isDark ? Colors.white : const Color(0xff0F172A);

    // final statusOutlineBorderColor = isDark ? Colors.white54 : const Color(0xff0F172A);
    // final statusOutlineTextColor = isDark ? Colors.white : const Color(0xff0F172A);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slot ${slot.name}",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleTextColor,
                ),
              ),
              _StatusBadge(status: slot.status),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.layers_outlined,
            label: 'Floor',
            value: slot.floor.toString(),
          ),
          const SizedBox(height: 4),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: slot.location,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Expanded(
              //   child: _ActionButton(
              //     label: "Navigate",
              //     onPressed: () {},
              //     backgroundColor: navigateBtnBgColor,
              //     textColor: navigateBtnTextColor,
              //   ),
              // ),
              // const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: "View Map",
                  onPressed: () {
                    final tempCar = CarEntity(
                      id: slot.id,
                      model: '',
                      color: '',
                      plateNumber: slot.name,
                      parkingLocation:
                          'Floor ${slot.floor}, Section ${slot.location} - Slot ${slot.name}',
                      slotId: int.tryParse(slot.id),
                    );
                    VehicleMapDialog.show(context, tempCar);
                  },
                  backgroundColor: viewMapBtnBgColor,
                  textColor: viewMapBtnTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: "Override",
                  icon: Icons.tune_rounded,
                  onPressed: () => _showOverrideStatusBottomSheet(context),
                  backgroundColor: isDark
                      ? const Color(0xFF334155)
                      : const Color.fromARGB(255, 92, 114, 134),
                  textColor: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color.fromARGB(255, 247, 247, 248),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOverrideStatusBottomSheet(BuildContext context) {
    final cubit = context.read<ManageSlotsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Override Slot Status",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Manually override the occupancy state of Slot ${slot.name}.",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                if (slot.status != SlotStatus.available) ...[
                  _buildStatusOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Available",
                    description: "Set slot as free/unoccupied",
                    isOccupied: false,
                    icon: Icons.check_circle,
                    color: isDark
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFF15803D),
                  ),
                  const SizedBox(height: 12),
                ],
                if (slot.status != SlotStatus.occupied) ...[
                  _buildStatusOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Occupied",
                    description: "Set slot as physically occupied",
                    isOccupied: true,
                    icon: Icons.cancel,
                    color: isDark
                        ? const Color(0xFFF87171)
                        : const Color(0xFFDC2626),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    BuildContext sheetContext,
    ManageSlotsCubit cubit, {
    required String title,
    required String description,
    required bool isOccupied,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        Navigator.pop(sheetContext);

        final success = await cubit.updateSlotStatus(
          slotId: slot.id,
          isOccupied: isOccupied,
          currentFloor: slot.floor,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? "Successfully set Slot ${slot.name} to ${isOccupied ? 'Occupied' : 'Available'}."
                    : "Failed to update slot status.",
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SlotStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case SlotStatus.available:
        statusColor =
            isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
        statusText = "Available";
        statusIcon = Icons.check_circle;
        break;
      case SlotStatus.maintenance:
        statusColor =
            isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
        statusText = "Maintenance";
        statusIcon = Icons.info_outline;
        break;
      case SlotStatus.occupied:
        statusColor =
            isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
        statusText = "Occupied";
        statusIcon = Icons.cancel;
        break;
      case SlotStatus.booked:
        statusColor =
            isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
        statusText = "Booked";
        statusIcon = Icons.bookmark_added;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: GoogleFonts.spaceGrotesk(
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : const Color(0xff475569);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xff94A3B8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const _ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: textColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final labelTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final valueTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: labelTextColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueTextColor,
          ),
        ),
      ],
    );
  }
}
