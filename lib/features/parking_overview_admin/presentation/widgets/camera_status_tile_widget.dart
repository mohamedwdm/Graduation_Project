import 'package:flutter/material.dart';
import '../../domain/entities/camera_status_entity.dart';

class CameraStatusTileWidget extends StatelessWidget {
  final CameraStatusEntity camera;

  const CameraStatusTileWidget({
    super.key,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: camera.isOnline
                ? const Color(0xff08EA17)
                : const Color(0xffEAB308).withOpacity(0.2),
            child: Icon(
              Icons.videocam_outlined,
              color: camera.isOnline ? Colors.white : const Color(0xffEAB308),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camera.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E293B),
                  ),
                ),
                Text(
                  camera.timeAgo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
