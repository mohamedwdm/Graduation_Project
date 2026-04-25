import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
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
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  late final TextEditingController _yearController;
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
    _modelController = TextEditingController(text: widget.car.model);
    _plateController = TextEditingController(text: widget.car.plateNumber);
    _colorController = TextEditingController(text: widget.car.color);
    _yearController = TextEditingController(text: '2024'); // default since not in entity
  }

  @override
  void dispose() {
    _modelController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedCar = SavedCarEntity(
        id: widget.car.id,
        model: _modelController.text,
        color: _colorController.text,
        plateNumber: _plateController.text,
      );
      context.read<SavedCarFormCubit>().updateCar(updatedCar);
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
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1152D4)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Update Car Details',
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info, color: Color(0xFF1152D4), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Update your vehicle information to ensure accurate parking slot matching and charging compatibility.',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1152D4),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Car Model'),
                _buildTextField(
                  controller: _modelController,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('License Plate'),
                          _buildTextField(
                            controller: _plateController,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Year'),
                          _buildTextField(
                            controller: _yearController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Color'),
                          _buildTextField(
                            controller: _colorController,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Car Type'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
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
                                decoration: const InputDecoration(border: InputBorder.none),
                                items: _carTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                        ],
                      ),
                    ),
                  ],
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
                    onPressed: () {
                      context.read<SavedCarFormCubit>().deleteCar(widget.car.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFFEE2E2)),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
