import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
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
    final imageBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final imageIconColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final modelTextColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final detailTextColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final buttonTextColor = isDark ? Colors.white70 : const Color(0xFF334155);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image with local/fallback placeholder (80x80)
                GestureDetector(
                  onTap: (car.imagePath != null && car.imagePath!.isNotEmpty)
                      ? () {
                          final imageUrl = car.imagePath!.startsWith('http')
                              ? car.imagePath!
                              : '${EnvConfig.instance.apiBaseUrl}/${car.imagePath!.replaceFirst(RegExp(r'^/'), '')}';
                          ImagePreviewDialog.show(
                            context,
                            imageUrl,
                            'Vehicle ${car.plateNumber}',
                          );
                        }
                      : null,
                  child: MouseRegion(
                    cursor: (car.imagePath != null && car.imagePath!.isNotEmpty)
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: imageBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (car.imagePath != null && car.imagePath!.isNotEmpty)
                            ? Image.network(
                                car.imagePath!.startsWith('http')
                                    ? car.imagePath!
                                    : '${EnvConfig.instance.apiBaseUrl}/${car.imagePath!.replaceFirst(RegExp(r'^/'), '')}',
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
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
                                        color: Color(0xFF00A24F),
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
                const SizedBox(width: 16),
                // Car Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.plateNumber,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.model,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: modelTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        car.color,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: detailTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.parkingLocation,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: detailTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Horizontal Border
          Container(
            height: 1,
            color: dividerColor,
          ),
          // Action Buttons
          Row(
            children: [
              // View on Map
              Expanded(
                child: InkWell(
                  onTap: () {
                    final token = sl<AuthLocalDataSource>().getToken();
                    final isGuest = token == 'guest_token_from_server';
                    if (isGuest) {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Authentication Required',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'You are currently in Guest Mode. Please sign in or register to view the vehicle map.',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                context.go('/');
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  color: Color(0xff00A24F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      VehicleMapDialog.show(context, car.plateNumber);
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigation_outlined,
                            size: 19, color: buttonTextColor),
                        const SizedBox(width: 8),
                        Text(
                          "Navigate to Car",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: buttonTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // // vertical separator
              // Container(width: 1, height: 52, color: dividerColor),
              // // Navigate
              // Expanded(
              //   child: InkWell(
              //     onTap: null, // Disabled
              //     child: Container(
              //       height: 52,
              //       alignment: Alignment.center,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           const Icon(Icons.navigation_outlined,
              //               size: 18, color: Color(0xFF13EC5B)),
              //           const SizedBox(width: 8),
              //           Text(
              //             "Navigate",
              //             style: GoogleFonts.spaceGrotesk(
              //               fontWeight: FontWeight.w700,
              //               fontSize: 16,
              //               color: const Color(0xFF13EC5B),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
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
      builder: (context) => ImagePreviewDialog(imageUrl: imageUrl, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: titleColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    InteractiveViewer(
                      maxScale: 4.0,
                      minScale: 1.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00A24F),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pinch to zoom and drag to pan',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

