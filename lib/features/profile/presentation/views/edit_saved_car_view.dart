import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../widgets/drag_drop_color_selector.dart';
import '../../domain/entities/saved_car_entity.dart';
import '../manager/saved_car_form_cubit/saved_car_form_cubit.dart';
import '../manager/saved_car_form_cubit/saved_car_form_state.dart';

class EditSavedCarView extends StatefulWidget {
  final SavedCarEntity car;

  const EditSavedCarView({super.key, required this.car});

  @override
  State<EditSavedCarView> createState() => _EditSavedCarViewState();
}

class _EditSavedCarViewState extends State<EditSavedCarView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plateController;
  late final TextEditingController _colorController;
  String _selectedCarType = 'Sedan';

  final List<String> _carTypes = [
    'Sedan',
    'SUV',
    'Hatchbacks',
    'Pickup Truck',
    'Sports Car',
  ];

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.car.plateNumber);
    _colorController = TextEditingController(text: widget.car.color);
    _selectedCarType = _carTypes.contains(widget.car.model) ? widget.car.model : 'Sedan';
  }

  @override
  void dispose() {
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedCar = SavedCarEntity(
        id: widget.car.id,
        model: _selectedCarType,
        color: _colorController.text,
        plateNumber: _plateController.text,
      );
      context.read<SavedCarFormCubit>().updateCar(updatedCar);
    }
  }

  void _showDeleteConfirmationDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final contentColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final cancelColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Car',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this car (${widget.car.plateNumber})? This action cannot be undone.',
          style: GoogleFonts.manrope(
            color: contentColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(
                color: cancelColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SavedCarFormCubit>().deleteCar(widget.car.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F6F8);
    final appBarBgColor = isDark ? const Color(0xFF1E293B) : Colors.white.withOpacity(0.9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0D121B);
    final backButtonColor = isDark ? Colors.white : const Color(0xFF1152D4);
    
    // Info Container
    final infoBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);
    final infoTextColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1152D4);
    
    // Dropdown styling
    final dropdownBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final dropdownTextColor = isDark ? Colors.white : Colors.black;

    // Delete Button styling
    final deleteButtonBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final deleteButtonBorder = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);

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
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: appBarBgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: backButtonColor),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Update Car Details',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: infoBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: infoTextColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Update your vehicle information to ensure accurate parking slot matching.',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: infoTextColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('License Plate'),
                _buildTextField(
                  controller: _plateController,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
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
                    color: dropdownBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarType,
                      dropdownColor: dropdownBgColor,
                      decoration: const InputDecoration(border: InputBorder.none),
                      items: _carTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: dropdownTextColor,
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
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.save, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save Changes',
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _showDeleteConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deleteButtonBg,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: deleteButtonBorder),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Delete Car',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: labelColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
