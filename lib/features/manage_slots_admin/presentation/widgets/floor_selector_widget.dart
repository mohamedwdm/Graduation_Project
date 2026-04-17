import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloorSelectorWidget extends StatelessWidget {
  final int selectedFloor;
  final Function(int) onFloorSelected;

  const FloorSelectorWidget({
    super.key,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          _FloorButton(
            floor: 1,
            isSelected: selectedFloor == 1,
            onPressed: () => onFloorSelected(1),
          ),
          _FloorButton(
            floor: 2,
            isSelected: selectedFloor == 2,
            onPressed: () => onFloorSelected(2),
          ),
          _FloorButton(
            floor: 3,
            isSelected: selectedFloor == 3,
            onPressed: () => onFloorSelected(3),
          ),
        ],
      ),
    );
  }
}

class _FloorButton extends StatelessWidget {
  final int floor;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FloorButton({
    required this.floor,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            "Floor $floor",
            style: GoogleFonts.spaceGrotesk(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
              color: isSelected ? const Color(0xff0F172A) : const Color(0xff64748B),
            ),
          ),
        ),
      ),
    );
  }
}
