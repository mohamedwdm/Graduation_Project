import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../widgets/drag_drop_color_selector.dart';
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
  String _selectedCarType = 'Toyota';

  final List<String> _carTypes = [
    'Ashok Leyland',
    'Audi',
    'Bentley',
    'Bharat Benz',
    'BMW',
    'Eicher Motors',
    'Ford',
    'Honda',
    'Hyundai',
    'Jaguar',
    'KIA',
    'Land Rover',
    'Mahindra',
    'Maruti Suzuki',
    'Mercedes',
    'MG Motors',
    'Nissan',
    'Renault',
    'Rolls Royce',
    'Skoda',
    'Swaraj Mazda',
    'Tata',
    'Toyota',
    'Volkswagen',
    'Volvo',
    'Chevrolet',
    'Citreon',
    'Fiat',
    'Jeep',
  ];

  @override
  void dispose() {
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final plate = _plateController.text.trim();
      final finalPlate = plate.isEmpty
          ? 'UNKNOWN-${DateTime.now().millisecondsSinceEpoch}'
          : plate;
      final car = SavedCarEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        model: _selectedCarType,
        color: _colorController.text,
        plateNumber: finalPlate,
      );
      context.read<SavedCarFormCubit>().addCar(car);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final contentColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final buttonColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1152D4);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text(
              'Error',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.spaceGrotesk(
            color: contentColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.spaceGrotesk(
                color: buttonColor,
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
    final appBarBgColor = isDark ? const Color(0xFF1E293B) : Colors.white.withValues(alpha: 0.9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0D121B);
    final backButtonColor = isDark ? Colors.white : const Color(0xFF1152D4);
    
    // Dropdown styling
    final dropdownBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final dropdownTextColor = isDark ? Colors.white : Colors.black;

    return BlocListener<SavedCarFormCubit, SavedCarFormState>(
      listener: (context, state) {
        if (state is SavedCarFormSuccess) {
          context.pop(true);
        } else if (state is SavedCarFormError) {
          _showErrorDialog(context, state.message);
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
            'Add New Car',
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
                _buildLabel('License Plate'),
                _buildTextField(
                  controller: _plateController,
                  hint: 'e.g. ABC-1234',
                  validator: null,
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
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarType,
                      dropdownColor: dropdownBgColor,
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
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade400;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
        boxShadow: isDark
            ? null
            : [
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
            fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: hintColor,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

