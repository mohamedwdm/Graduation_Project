import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../profile/presentation/manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../../../profile/presentation/manager/saved_cars_cubit/saved_cars_state.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_cubit.dart';
import '../../../slots/presentation/manager/slots_cubit/slots_state.dart';
import '../manager/reservation_cubit/reservation_cubit.dart';
import '../manager/reservation_cubit/reservation_state.dart';
import 'package:google_fonts/google_fonts.dart';

class ReserveSlotView extends StatefulWidget {
  final String? preselectedSlotCode;
  const ReserveSlotView({super.key, this.preselectedSlotCode});

  @override
  State<ReserveSlotView> createState() => _ReserveSlotViewState();
}

class _ReserveSlotViewState extends State<ReserveSlotView> {
  final _formKey = GlobalKey<FormState>();
  final _customPlateController = TextEditingController();

  String? _selectedSlotCode;
  String? _selectedSavedCarPlate;
  bool _useCustomPlate = false;

  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(const Duration(hours: 2));
    _selectedSlotCode = widget.preselectedSlotCode;

    // Fetch saved cars & slots
    context.read<SavedCarsCubit>().loadSavedCars();
    context.read<SlotsCubit>().loadSlots();
  }

  @override
  void dispose() {
    _customPlateController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final year = dt.year;
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final picked = await _pickDateTime(context, _startTime);
    if (picked != null) {
      setState(() {
        _startTime = picked;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 2));
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final picked = await _pickDateTime(context, _endTime);
    if (picked != null) {
      if (picked.isBefore(_startTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time cannot be before start time'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<DateTime?> _pickDateTime(BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(minutes: 10)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff00A24F),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xff00A24F),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return null;
    if (!mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff00A24F),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSlotCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a parking slot'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      final plate = _useCustomPlate ? _customPlateController.text : _selectedSavedCarPlate;
      if (plate == null || plate.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select or enter a vehicle plate number'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      context.read<ReservationCubit>().reserveSlot(
            slotCode: _selectedSlotCode!,
            plateNumber: plate.trim(),
            startTime: _startTime,
            endTime: _endTime,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is ReservationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reserved Slot ${_selectedSlotCode} successfully!'),
              backgroundColor: const Color(0xff00A24F),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ReservationError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Reservation Failed',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              content: Text(
                state.message,
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF475569),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xff00A24F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Reserve Parking Slot',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reserve Slot',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secure a parking space in advance for your vehicle.',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SELECT VEHICLE SECTION
                  _buildSectionHeader('Select Vehicle'),
                  const SizedBox(height: 12),
                  BlocBuilder<SavedCarsCubit, SavedCarsState>(
                    builder: (context, state) {
                      List<DropdownMenuItem<String>> carItems = [];

                      if (state is SavedCarsLoaded) {
                        carItems = state.cars.map((car) {
                          return DropdownMenuItem<String>(
                            value: car.plateNumber,
                            child: Text(
                              '${car.model} (${car.plateNumber})',
                              style: GoogleFonts.spaceGrotesk(),
                            ),
                          );
                        }).toList();
                      }

                      // Automatically select first car if available and none selected yet
                      if (state is SavedCarsLoaded && state.cars.isNotEmpty && _selectedSavedCarPlate == null && !_useCustomPlate) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedSavedCarPlate = state.cars.first.plateNumber;
                          });
                        });
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: _useCustomPlate,
                                activeColor: const Color(0xff00A24F),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _useCustomPlate = value;
                                    });
                                  }
                                },
                              ),
                              Text(
                                'Use Saved Car',
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const Spacer(),
                              Radio<bool>(
                                value: true,
                                groupValue: _useCustomPlate,
                                activeColor: const Color(0xff00A24F),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _useCustomPlate = value;
                                    });
                                  }
                                },
                              ),
                              Text(
                                'Enter Plate Number',
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (!_useCustomPlate)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSavedCarPlate,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  hint: Text(
                                    state is SavedCarsLoading ? 'Loading cars...' : 'Choose a car',
                                    style: GoogleFonts.spaceGrotesk(color: const Color(0xFF94A3B8)),
                                  ),
                                  items: carItems,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedSavedCarPlate = val;
                                    });
                                  },
                                ),
                              ),
                            )
                          else
                            TextFormField(
                              controller: _customPlateController,
                              style: GoogleFonts.spaceGrotesk(),
                              decoration: InputDecoration(
                                hintText: 'Enter plate number (e.g. 123 ABC)',
                                hintStyle: GoogleFonts.spaceGrotesk(color: const Color(0xFF94A3B8)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xff00A24F), width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (_useCustomPlate && (value == null || value.trim().isEmpty)) {
                                  return 'Please enter plate number';
                                }
                                return null;
                              },
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // PARKING SLOT SECTION
                  _buildSectionHeader('Select Parking Slot'),
                  const SizedBox(height: 12),
                  BlocBuilder<SlotsCubit, SlotsState>(
                    builder: (context, state) {
                      List<DropdownMenuItem<String>> slotItems = [];

                      if (state is SlotsLoaded) {
                        // Filter available slots
                        final availableSlots = state.slots.where((slot) => slot.isAvailable).toList();
                        slotItems = availableSlots.map((slot) {
                          return DropdownMenuItem<String>(
                            value: slot.slotId,
                            child: Text(
                              'Slot ${slot.slotId} (Floor ${slot.floor})',
                              style: GoogleFonts.spaceGrotesk(),
                            ),
                          );
                        }).toList();
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSlotCode,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            hint: Text(
                              state is SlotsLoading ? 'Loading slots...' : 'Choose an available slot',
                              style: GoogleFonts.spaceGrotesk(color: const Color(0xFF94A3B8)),
                            ),
                            items: slotItems,
                            onChanged: (val) {
                              setState(() {
                                _selectedSlotCode = val;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // TIMEFRAME SECTION
                  _buildSectionHeader('Reservation Timeframe'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStartTime(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Time',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatDateTime(_startTime),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectEndTime(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Time',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatDateTime(_endTime),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // SUBMIT BUTTON
                  BlocBuilder<ReservationCubit, ReservationState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          backgroundcolor: const Color(0xff00A24F),
                          textcolor: Colors.white,
                          text: 'CONFIRM RESERVATION',
                          isLoading: state is ReservationLoading,
                          onPressed: _submit,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
      ),
    );
  }
}
