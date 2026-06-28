import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/vehicle_map_cubit/vehicle_map_cubit.dart';
import '../manager/vehicle_map_cubit/vehicle_map_state.dart';

class VehicleMapDialog extends StatelessWidget {
  final String plateNumber;

  const VehicleMapDialog({super.key, required this.plateNumber});

  static Future<void> show(BuildContext context, String plateNumber) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => VehicleMapDialog(plateNumber: plateNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return BlocProvider<VehicleMapCubit>(
      create: (context) => sl<VehicleMapCubit>()..fetchVehicleMap(plateNumber),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: dialogBgColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Location Map',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vehicle: $plateNumber',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: titleColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content
              Expanded(
                child: BlocBuilder<VehicleMapCubit, VehicleMapState>(
                  builder: (context, state) {
                    if (state is VehicleMapLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00A24F),
                        ),
                      );
                    }
                    if (state is VehicleMapError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 15,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A24F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<VehicleMapCubit>().fetchVehicleMap(plateNumber);
                                },
                                child: Text(
                                  'Retry',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is VehicleMapLoaded) {
                      final map = state.mapEntity;
                      final baseUrl = EnvConfig.instance.apiBaseUrl;
                      final relativeMapPath = map.mapPath.replaceFirst(RegExp(r'^/'), '');
                      final mapUrl = '$baseUrl/$relativeMapPath';

                      return Column(
                        children: [
                          // Location details header/cards
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildLocationDetail(
                                  Icons.layers_outlined,
                                  'Floor',
                                  map.floor,
                                  context,
                                ),
                                Container(
                                  width: 1,
                                  height: 32,
                                  color: borderColor,
                                ),
                                _buildLocationDetail(
                                  Icons.grid_view_outlined,
                                  'Section',
                                  map.section,
                                  context,
                                ),
                                Container(
                                  width: 1,
                                  height: 32,
                                  color: borderColor,
                                ),
                                _buildLocationDetail(
                                  Icons.local_parking_outlined,
                                  'Slot',
                                  map.slot,
                                  context,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Zoomable Map Container
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: InteractiveViewer(
                                maxScale: 5.0,
                                minScale: 0.5,
                                child: Image.network(
                                  mapUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image_outlined,
                                            size: 48,
                                            color: subtitleColor,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Failed to load map image',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 14,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF00A24F),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pinch to zoom and drag to pan the map layout',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: subtitleColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDetail(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final labelColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: labelColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
