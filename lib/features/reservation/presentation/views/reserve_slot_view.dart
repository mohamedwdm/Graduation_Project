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
import 'package:go2car/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../core/di/injection_container.dart';

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
  int? _selectedFloor;
  String? _selectedSectionNameDisplay;
  String? _selectedSavedCarPlate;
  bool _useCustomPlate = false;
  String? _userType;

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
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    try {
      final user = await sl<AuthLocalDataSource>().getCachedUser();
      if (user != null && mounted) {
        setState(() {
          _userType = user.userType;
        });
      }
    } catch (_) {}
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

  Future<DateTime?> _pickDateTime(
      BuildContext context, DateTime initial) async {
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

      final plate = _useCustomPlate
          ? _customPlateController.text
          : _selectedSavedCarPlate;
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

  void _showPaymentDialog() {
    if (!_formKey.currentState!.validate()) return;
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

    String selectedPayment = 'card';
    int currentStep = 1;

    final cardNumberController = TextEditingController(text: "4242 4242 4242 4242");
    final expiryController = TextEditingController(text: "12/28");
    final cvvController = TextEditingController(text: "123");
    final paypalEmailController = TextEditingController(text: "user@example.com");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                currentStep == 1 ? 'Payment Method' : 'Enter Details',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFF0F172A),
                ),
              ),
              content: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: currentStep == 1
                    ? Column(
                        key: const ValueKey(1),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Choose how you would like to pay for your reservation.',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentOption(
                            title: 'Credit / Debit Card',
                            subtitle: 'Visa, Mastercard, etc.',
                            icon: Icons.credit_card,
                            value: 'card',
                            selectedValue: selectedPayment,
                            onTap: () => setDialogState(() => selectedPayment = 'card'),
                          ),
                          const SizedBox(height: 8),
                          _buildPaymentOption(
                            title: 'PayPal',
                            subtitle: 'Pay via PayPal account',
                            icon: Icons.account_balance_wallet,
                            value: 'paypal',
                            selectedValue: selectedPayment,
                            onTap: () => setDialogState(() => selectedPayment = 'paypal'),
                          ),
                          const SizedBox(height: 8),
                          _buildPaymentOption(
                            title: 'Apple / Google Pay',
                            subtitle: 'Instant mobile checkout',
                            icon: Icons.phone_android,
                            value: 'mobile_pay',
                            selectedValue: selectedPayment,
                            onTap: () => setDialogState(() => selectedPayment = 'mobile_pay'),
                          ),
                          const SizedBox(height: 8),
                          _buildPaymentOption(
                            title: 'Pay at Location',
                            subtitle: 'Pay at parking entrance gate',
                            icon: Icons.payments_outlined,
                            value: 'cash',
                            selectedValue: selectedPayment,
                            onTap: () => setDialogState(() => selectedPayment = 'cash'),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey(2),
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedPayment == 'card') ...[
                            Text(
                              'Credit Card Details',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: cardNumberController,
                              style: GoogleFonts.spaceGrotesk(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Card Number',
                                labelStyle: GoogleFonts.spaceGrotesk(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: expiryController,
                                    style: GoogleFonts.spaceGrotesk(fontSize: 14),
                                    decoration: InputDecoration(
                                      labelText: 'Expiry Date',
                                      labelStyle: GoogleFonts.spaceGrotesk(fontSize: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: cvvController,
                                    style: GoogleFonts.spaceGrotesk(fontSize: 14),
                                    decoration: InputDecoration(
                                      labelText: 'CVV',
                                      labelStyle: GoogleFonts.spaceGrotesk(fontSize: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ] else if (selectedPayment == 'paypal') ...[
                            Text(
                              'PayPal Authentication',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: paypalEmailController,
                              style: GoogleFonts.spaceGrotesk(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'PayPal Email / Account',
                                labelStyle: GoogleFonts.spaceGrotesk(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              obscureText: true,
                              style: GoogleFonts.spaceGrotesk(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: GoogleFonts.spaceGrotesk(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ] else if (selectedPayment == 'mobile_pay') ...[
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.contactless_outlined, size: 60, color: Color(0xff00A24F)),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Simulating Mobile Pay...',
                                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Place phone near payment terminal or confirm popup request.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.spaceGrotesk(fontSize: 12, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.info_outline_rounded, size: 60, color: Color(0xff00A24F)),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Pay at Parking Entrance',
                                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'No card details are needed. You will pay cash or POS card machine at the gate upon entry.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.spaceGrotesk(fontSize: 12, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (currentStep == 2) {
                      setDialogState(() => currentStep = 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    currentStep == 2 ? 'Back' : 'Cancel',
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00A24F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (currentStep == 1) {
                      setDialogState(() => currentStep = 2);
                    } else {
                      Navigator.pop(context);
                      _submit();
                    }
                  },
                  child: Text(
                    currentStep == 1 ? 'Next' : 'Pay & Confirm',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;
    final activeColor = const Color(0xff00A24F);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? activeColor : const Color(0xFF64748B),
                size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: activeColor, size: 20)
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is ReservationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Reservation request submitted! Awaiting admin approval.'),
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
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 28),
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
                      if (state is SavedCarsLoaded &&
                          state.cars.isNotEmpty &&
                          _selectedSavedCarPlate == null &&
                          !_useCustomPlate) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedSavedCarPlate =
                                state.cars.first.plateNumber;
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSavedCarPlate,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  hint: Text(
                                    state is SavedCarsLoading
                                        ? 'Loading cars...'
                                        : 'Choose a car',
                                    style: GoogleFonts.spaceGrotesk(
                                        color: const Color(0xFF94A3B8)),
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
                                hintStyle: GoogleFonts.spaceGrotesk(
                                    color: const Color(0xFF94A3B8)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xff00A24F), width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.redAccent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.redAccent, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (_useCustomPlate &&
                                    (value == null || value.trim().isEmpty)) {
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

                  BlocBuilder<SlotsCubit, SlotsState>(
                    builder: (context, state) {
                      List<DropdownMenuItem<int>> floorItems = [];
                      List<DropdownMenuItem<String>> sectionItems = [];
                      List<DropdownMenuItem<String>> slotItems = [];

                      if (state is SlotsLoaded) {
                        final availableSlots = state.slots.where((s) {
                          final isAvailableOrSelected =
                              s.isAvailable || s.slotId == _selectedSlotCode;

                          final type = s.slotType.toLowerCase();
                          final isHandicap = type == 'handicap' ||
                              type == 'disabled' ||
                              type == 'accessible' ||
                              s.isAccessible;

                          if (_userType == 'handicap') {
                            return isAvailableOrSelected &&
                                (type == 'normal' ||
                                    isHandicap ||
                                    type.isEmpty);
                          } else {
                            return isAvailableOrSelected &&
                                (type == 'normal' || type.isEmpty);
                          }
                        }).toList();

                        // Resolve preselection
                        if (_selectedSlotCode != null &&
                            _selectedFloor == null) {
                          for (final slot in availableSlots) {
                            if (slot.slotId == _selectedSlotCode) {
                              _selectedFloor = slot.floor;
                              _selectedSectionNameDisplay =
                                  slot.sectionNameDisplay;
                              break;
                            }
                          }
                        }

                        // Floors
                        final floorsList = availableSlots
                            .map((s) => s.floor)
                            .toSet()
                            .toList()
                          ..sort();
                        floorItems = floorsList.map((f) {
                          return DropdownMenuItem<int>(
                            value: f,
                            child: Text(
                              'Floor $f',
                              style: GoogleFonts.spaceGrotesk(),
                            ),
                          );
                        }).toList();

                        // Sections
                        if (_selectedFloor != null) {
                          final sectionsList = availableSlots
                              .where((s) => s.floor == _selectedFloor)
                              .map((s) => s.sectionNameDisplay)
                              .toSet()
                              .toList()
                            ..sort();
                          sectionItems = sectionsList.map((sec) {
                            return DropdownMenuItem<String>(
                              value: sec,
                              child: Text(
                                sec,
                                style: GoogleFonts.spaceGrotesk(),
                              ),
                            );
                          }).toList();
                        }

                        // Slots
                        if (_selectedFloor != null &&
                            _selectedSectionNameDisplay != null) {
                          final slotsList = availableSlots
                              .where((s) =>
                                  s.floor == _selectedFloor &&
                                  s.sectionNameDisplay ==
                                      _selectedSectionNameDisplay)
                              .toList();
                          slotItems = slotsList.map((slot) {
                            return DropdownMenuItem<String>(
                              value: slot.slotId,
                              child: Text(
                                'Slot ${slot.slotNumber}',
                                style: GoogleFonts.spaceGrotesk(),
                              ),
                            );
                          }).toList();
                        }
                      }

                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final disabledColor = isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FLOOR DROPDOWN
                          _buildSectionHeader('Select Floor'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<int>(
                                value: _selectedFloor,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                hint: Text(
                                  state is SlotsLoading
                                      ? 'Loading floors...'
                                      : 'Choose a floor',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: const Color(0xFF94A3B8)),
                                ),
                                items: floorItems,
                                onChanged: state is! SlotsLoaded
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedFloor = val;
                                          _selectedSectionNameDisplay = null;
                                          _selectedSlotCode = null;
                                        });
                                      },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // SECTION DROPDOWN
                          _buildSectionHeader('Select Section'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: _selectedFloor == null
                                  ? disabledColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: _selectedSectionNameDisplay,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                hint: Text(
                                  _selectedFloor == null
                                      ? 'Select a floor first'
                                      : 'Choose a section',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: const Color(0xFF94A3B8)),
                                ),
                                items: sectionItems,
                                onChanged: _selectedFloor == null
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedSectionNameDisplay = val;
                                          _selectedSlotCode = null;
                                        });
                                      },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // SLOT DROPDOWN
                          _buildSectionHeader('Select Slot'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: _selectedSectionNameDisplay == null
                                  ? disabledColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: _selectedSlotCode,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                hint: Text(
                                  _selectedSectionNameDisplay == null
                                      ? 'Select a section first'
                                      : 'Choose a slot',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: const Color(0xFF94A3B8)),
                                ),
                                items: slotItems,
                                onChanged: _selectedSectionNameDisplay == null
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedSlotCode = val;
                                        });
                                      },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),

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
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
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
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
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
                          text: 'PAY TO RESERVE',
                          isLoading: state is ReservationLoading,
                          onPressed: _showPaymentDialog,
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
