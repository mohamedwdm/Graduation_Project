import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/saved_car_entity.dart';
import '../manager/saved_car_form_cubit/saved_car_form_cubit.dart';
import '../manager/saved_car_form_cubit/saved_car_form_state.dart';

class AddSavedCarView extends StatefulWidget {
  const AddSavedCarView({super.key});

  @override
  State<AddSavedCarView> createState() => _AddSavedCarViewState();
}

class _AddSavedCarViewState extends State<AddSavedCarView> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _colorController = TextEditingController();
  String _selectedCarType = 'Sedan';

  final List<String> _carTypes = [
    'Sedan',
    'SUV',
    'Hatchbacks',
    'Pickup Truck',
    'Sports Car',
  ];

  @override
  void dispose() {
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final car = SavedCarEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        model: _selectedCarType,
        color: _colorController.text,
        plateNumber: _plateController.text,
      );
      context.read<SavedCarFormCubit>().addCar(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedCarFormCubit, SavedCarFormState>(
      listener: (context, state) {
        if (state is SavedCarFormSuccess) {
          context.pop(true);
        } else if (state is SavedCarFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F8),
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1152D4)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Add New Car',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D121B),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('License Plate'),
                _buildTextField(
                  controller: _plateController,
                  hint: 'e.g. ABC-1234',
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Color'),
                FormField<String>(
                  validator: (value) {
                    if (_colorController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DragDropColorSelector(
                          controller: _colorController,
                          onChanged: () {
                            formState.didChange(_colorController.text);
                          },
                        ),
                        if (formState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                            child: Text(
                              formState.errorText!,
                              style: GoogleFonts.manrope(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel('Car Type'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarType,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      items: _carTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCarType = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                BlocBuilder<SavedCarFormCubit, SavedCarFormState>(
                  builder: (context, state) {
                    final isLoading = state is SavedCarFormLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1152D4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_circle,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Add Car',
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.manrope(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

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
    final selectedColorName = widget.controller.text;
    final selectedColor = _colorMap[selectedColorName];

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

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: selectedColor ??
                      (isHovered ? const Color(0xFFEFF6FF) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isHovered
                        ? const Color(0xFF1152D4)
                        : (selectedColor != null
                            ? Colors.transparent
                            : const Color(0xFFE2E8F0)),
                    width: 2,
                    style: selectedColor != null
                        ? BorderStyle.none
                        : BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
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
                        color: isHovered
                            ? const Color(0xFF1152D4)
                            : const Color(0xFF64748B),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isHovered ? "Drop to Select!" : "Drop Selected Color Here",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isHovered
                              ? const Color(0xFF1152D4)
                              : const Color(0xFF64748B),
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
            color: const Color(0xFF64748B),
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
                        ? const Color(0xFF1152D4)
                        : (colorName == 'White'
                            ? const Color(0xFFCBD5E1)
                            : Colors.transparent),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                        color: isSelected
                            ? const Color(0xFF1152D4)
                            : const Color(0xFF64748B),
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
