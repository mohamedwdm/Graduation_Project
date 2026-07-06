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
    final noteTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    final viewMapBtnBgColor =
        isDark ? const Color(0xFF334155) : const Color(0xffE2E8F0);
    final viewMapBtnTextColor = isDark ? Colors.white : const Color(0xff0F172A);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Slot ${slot.name}",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeBadge(slot.slotType),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Floor ${slot.floor}, Section ${slot.location}",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: noteTextColor,
                    ),
                  ),
                ],
              ),
              _StatusBadge(status: slot.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (slot.slotType.toLowerCase() == 'vip')
                _buildFeatureTag(
                  context,
                  Icons.star_rounded,
                  'VIP',
                  customColor: const Color(0xFF7C3AED),
                ),
              if (slot.slotType.toLowerCase() == 'normal')
                _buildFeatureTag(
                  context,
                  Icons.directions_car_rounded,
                  'Normal',
                  customColor: const Color(0xFF475569),
                ),
              if (slot.slotType.toLowerCase() == 'disabled' ||
                  slot.slotType.toLowerCase() == 'handicap')
                _buildFeatureTag(
                  context,
                  Icons.accessible,
                  'Special Needs (Disabled)',
                  customColor: const Color(0xFFD97706),
                ),
              if (slot.slotType.toLowerCase() == 'maintenance')
                _buildFeatureTag(
                  context,
                  Icons.construction_rounded,
                  'Maintenance',
                  customColor: const Color(0xFFDC2626),
                ),
              if (slot.slotType.toLowerCase() == 'electric' ||
                  slot.slotType.toLowerCase() == 'ev')
                _buildFeatureTag(
                  context,
                  Icons.electric_bolt_outlined,
                  'Electric (For Electric Cars)',
                  customColor: Colors.blue,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
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
                  label: "Change Type",
                  icon: Icons.tune_rounded,
                  onPressed: () => _showOverrideTypeBottomSheet(context),
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

  Widget _buildTypeBadge(String type) {
    final t = type.toLowerCase();
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final IconData icon;
    final String label;

    if (t == 'vip') {
      bgColor = const Color(0xFFF5F3FF);
      borderColor = const Color(0xFF8B5CF6);
      textColor = const Color(0xFF7C3AED);
      icon = Icons.star_rounded;
      label = 'VIP';
    } else if (t == 'disabled' || t == 'handicap') {
      bgColor = const Color(0xFFFEF3C7);
      borderColor = const Color(0xFFF59E0B);
      textColor = const Color(0xFFD97706);
      icon = Icons.accessible;
      label = 'Special Needs';
    } else if (t == 'maintenance') {
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFEF4444);
      textColor = const Color(0xFFDC2626);
      icon = Icons.construction_rounded;
      label = 'Maintenance';
    } else if (t == 'electric' || t == 'ev') {
      bgColor = const Color(0xFFECFDF5);
      borderColor = const Color(0xFF10B981);
      textColor = const Color(0xFF059669);
      icon = Icons.electric_car_rounded;
      label = 'Electric';
    } else {
      bgColor = const Color(0xFFF1F5F9);
      borderColor = const Color(0xFF94A3B8);
      textColor = const Color(0xFF475569);
      icon = Icons.directions_car_rounded;
      label = 'Normal';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(BuildContext context, IconData icon, String text,
      {Color? customColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagColor =
        customColor ?? (isDark ? Colors.white70 : const Color(0xFF475569));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 19, color: tagColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: tagColor,
          ),
        ),
      ],
    );
  }

  void _showOverrideTypeBottomSheet(BuildContext context) {
    final cubit = context.read<ManageSlotsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentType = slot.slotType.toLowerCase();

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
                  "Override Slot Type",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Manually change the type designation for Slot ${slot.name}.",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                if (currentType != 'normal') ...[
                  _buildTypeOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Normal",
                    description: "Standard parking space",
                    slotType: "normal",
                    icon: Icons.directions_car_rounded,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                  ),
                  const SizedBox(height: 12),
                ],
                if (currentType != 'vip') ...[
                  _buildTypeOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "VIP",
                    description: "Premium space reserved for VIPs",
                    slotType: "vip",
                    icon: Icons.star_rounded,
                    color: isDark
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFFD97706),
                  ),
                  const SizedBox(height: 12),
                ],
                if (currentType != 'disabled' && currentType != 'handicap') ...[
                  _buildTypeOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Disabled",
                    description: "Accessible space with extra room",
                    slotType: "disabled",
                    icon: Icons.accessible_rounded,
                    color: isDark
                        ? const Color(0xFF60A5FA)
                        : const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 12),
                ],
                if (currentType != 'maintenance') ...[
                  _buildTypeOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Maintenance",
                    description: "Temporary block for service",
                    slotType: "maintenance",
                    icon: Icons.construction_rounded,
                    color: isDark
                        ? const Color(0xFFF87171)
                        : const Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 12),
                ],
                if (currentType != 'electric' && currentType != 'ev') ...[
                  _buildTypeOption(
                    context,
                    sheetContext,
                    cubit,
                    title: "Electric",
                    description: "Charging station for electric vehicles",
                    slotType: "electric",
                    icon: Icons.electric_car_rounded,
                    color: isDark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF10B981),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeOption(
    BuildContext context,
    BuildContext sheetContext,
    ManageSlotsCubit cubit, {
    required String title,
    required String description,
    required String slotType,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        Navigator.pop(sheetContext);

        final success = await cubit.updateSlotType(
          slotId: slot.id,
          slotType: slotType,
          currentFloor: slot.floor,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? "Successfully set Slot ${slot.name} to $title."
                    : "Failed to update slot type.",
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

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const _ActionButton({
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
