import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/env_config.dart';
import '../../domain/entities/car_entity.dart';
import 'vehicle_map_dialog.dart';

class CarCard extends StatelessWidget {
  final CarEntity car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final imageBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final imageIconColor = isDark ? Colors.white30 : const Color(0xFF94A3B8);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    
    const primaryColor = Color(0xFF00A24F);

    // Helper to get color values for the color indicator dot
    Color getCarColor(String colorName) {
      final name = colorName.toLowerCase().trim();
      switch (name) {
        case 'black': return Colors.black;
        case 'blue': return Colors.blue;
        case 'brown': return Colors.brown;
        case 'green': return Colors.green;
        case 'grey': return Colors.grey;
        case 'orange': return Colors.orange;
        case 'red': return Colors.red;
        case 'silver': return const Color(0xFFC0C0C0);
        case 'white': return Colors.white;
        case 'yellow': return Colors.yellow;
        default: return Colors.transparent;
      }
    }

    final carColorValue = getCarColor(car.color);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image on the Left (Half width)
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (car.imagePath != null && car.imagePath!.isNotEmpty)
                      ? () {
                          final imageUrl = car.imagePath!.startsWith('http')
                              ? car.imagePath!
                              : '${EnvConfig.instance.apiBaseUrl}/${car.imagePath!.replaceFirst(RegExp(r'^/'), '')}';
                          ImagePreviewDialog.show(
                            context,
                            imageUrl,
                            'Vehicle Details',
                          );
                        }
                      : null,
                  child: MouseRegion(
                    cursor: (car.imagePath != null && car.imagePath!.isNotEmpty)
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: Container(
                      height: 150,
                      color: imageBgColor,
                      child: (car.imagePath != null && car.imagePath!.isNotEmpty)
                          ? Image.network(
                              car.imagePath!.startsWith('http')
                                  ? car.imagePath!
                                  : '${EnvConfig.instance.apiBaseUrl}/${car.imagePath!.replaceFirst(RegExp(r'^/'), '')}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.directions_car,
                                    color: imageIconColor,
                                    size: 40,
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: primaryColor,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.directions_car,
                                color: imageIconColor,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              // Details on the Right (Half width)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Model — big bold heading
                      Text(
                        car.model,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.2,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Color — muted secondary text
                      Text(
                        car.color[0].toUpperCase() + car.color.substring(1),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Location — muted secondary text
                      Text(
                        car.parkingLocation,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          // Action Button
          InkWell(
            onTap: () {
              VehicleMapDialog.show(context, car, fetchByPlate: true);
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border(
                  top: BorderSide(color: primaryColor.withOpacity(0.2)),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.navigation_rounded,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Navigate to Car",
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewDialog extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImagePreviewDialog({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  static void show(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => ImagePreviewDialog(imageUrl: imageUrl, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Close on background tap
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Expanded Image View
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 1.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        color: const Color(0xFF1E293B),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.white60,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 300,
                        width: double.infinity,
                        color: const Color(0xFF1E293B),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A24F),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Top Close Button Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          // Bottom Helper text
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pinch to zoom and drag to pan',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

