import 'package:flutter/material.dart';

class FloorSelector extends StatelessWidget {
  final int selectedFloor;
  final ValueChanged<int> onFloorSelected;

  const FloorSelector({
    super.key,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  final List<String> _floors = const ['Floor 1', 'Floor 2', 'Floor 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _floors.length;

          return Stack(
            children: [
              /// 🔥 Moving Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                left: selectedFloor * itemWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: itemWidth,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🧩 Text Buttons
              Row(
                children: List.generate(_floors.length, (index) {
                  final isSelected = selectedFloor == index;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onFloorSelected(index),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFF64748B),
                          ),
                          child: Text(_floors[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
