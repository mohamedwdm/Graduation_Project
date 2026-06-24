import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DragDropColorSelector extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const DragDropColorSelector({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<DragDropColorSelector> createState() => _DragDropColorSelectorState();
}

class _DragDropColorSelectorState extends State<DragDropColorSelector> {
  final Map<String, Color> _colorMap = {
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Brown': Colors.brown,
    'Green': Colors.green,
    'Grey': Colors.grey,
    'Orange': Colors.orange,
    'Red': Colors.red,
    'Silver': const Color(0xFFC0C0C0),
    'White': Colors.white,
    'Yellow': Colors.yellow,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColorName = widget.controller.text;
    final selectedColor = _colorMap[selectedColorName];

    // Theme-specific colors
    final accentColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1152D4);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: DragTarget<String>(
            onAcceptWithDetails: (details) {
              setState(() {
                widget.controller.text = details.data;
              });
              widget.onChanged();
            },
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;
              final textColor = (selectedColorName == 'White' ||
                      selectedColorName == 'Yellow' ||
                      selectedColorName == 'Silver')
                  ? const Color(0xFF0F172A)
                  : Colors.white;

              final containerBg = selectedColor ?? 
                  (isDark 
                      ? (isHovered ? const Color(0xFF334155) : const Color(0xFF1E293B))
                      : (isHovered ? const Color(0xFFEFF6FF) : Colors.white));

              final containerBorderColor = isHovered
                  ? accentColor
                  : (selectedColor != null
                      ? Colors.transparent
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)));

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: containerBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: containerBorderColor,
                    width: 2,
                    style: selectedColor != null
                        ? BorderStyle.none
                        : BorderStyle.solid,
                  ),
                  boxShadow: isDark 
                      ? null 
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selectedColor != null) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: textColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedColorName.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.color_lens_outlined,
                        color: isHovered ? accentColor : subTextColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isHovered ? "Drop to Select!" : "Drop Selected Color Here",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isHovered ? accentColor : subTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Drag a color option:",
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: subTextColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: _colorMap.entries.map((entry) {
              final colorName = entry.key;
              final color = entry.value;
              final isSelected = selectedColorName == colorName;

              final circleWidget = Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? accentColor
                        : (colorName == 'White'
                            ? (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1))
                            : Colors.transparent),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isDark 
                      ? null 
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: (colorName == 'White' ||
                                colorName == 'Yellow' ||
                                colorName == 'Silver')
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        size: 20,
                      )
                    : null,
              );

              return Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: Column(
                  children: [
                    Draggable<String>(
                      data: colorName,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.85,
                          child: ScaleTransition(
                            scale: const AlwaysStoppedAnimation(1.2),
                            child: circleWidget,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.35,
                        child: circleWidget,
                      ),
                      child: circleWidget,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colorName,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? accentColor : subTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
