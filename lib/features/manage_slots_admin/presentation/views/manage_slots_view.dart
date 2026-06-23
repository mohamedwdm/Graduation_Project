import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../manager/manage_slots_cubit/manage_slots_cubit.dart';
import '../manager/manage_slots_cubit/manage_slots_state.dart';
import '../widgets/slot_card_widget.dart';
import '../widgets/floor_selector_widget.dart';

class ManageSlotsView extends StatefulWidget {
  const ManageSlotsView({super.key});

  @override
  State<ManageSlotsView> createState() => _ManageSlotsViewState();
}

class _ManageSlotsViewState extends State<ManageSlotsView> {
  int _currentFloor = 1;

  @override
  void initState() {
    super.initState();
    context.read<ManageSlotsCubit>().fetchSlots(_currentFloor);
  }

  void _onFloorChanged(int floor) {
    setState(() {
      _currentFloor = floor;
    });
    context.read<ManageSlotsCubit>().fetchSlots(floor);
  }

  void _showAddSlotDialog(BuildContext context) async {
    final cubit = context.read<ManageSlotsCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Show a loading dialog first while we load sections
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xff0F172A),
        ),
      ),
    );
    
    final sections = await cubit.loadSections();
    
    // Close the loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    } else {
      return;
    }
    
    if (sections.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to load parking sections or no sections available.')),
      );
      return;
    }
    
    // Now show the actual form dialog
    String slotCode = '';
    int? selectedSectionId = sections.first['id'] as int?;
    final formKey = GlobalKey<FormState>();
    
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                "Add Parking Slot",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: const Color(0xff0F172A),
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Slot Code",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xff64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "e.g. A-05",
                          hintStyle: GoogleFonts.manrope(
                            color: const Color(0xff94A3B8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xff0F172A), width: 1.5),
                          ),
                        ),
                        style: GoogleFonts.manrope(color: const Color(0xff0F172A)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a slot code';
                          }
                          return null;
                        },
                        onChanged: (val) => slotCode = val,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Parking Section",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xff64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedSectionId,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xff0F172A), width: 1.5),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: GoogleFonts.manrope(color: const Color(0xff0F172A), fontSize: 16),
                        items: sections.map((sec) {
                          final floorMap = sec['floor'] as Map?;
                          final floorName = floorMap != null ? (floorMap['floor_name'] ?? floorMap['floor_code'] ?? '') : '';
                          return DropdownMenuItem<int>(
                            value: sec['id'] as int,
                            child: Text(
                              "${sec['section_name']} (${floorName.isNotEmpty ? floorName : 'Floor ${sec['floor_id'] ?? ''}'})",
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedSectionId = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xffE2E8F0)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            // Show loading inside dialog or close it and run action
                            Navigator.of(dialogContext).pop();
                            
                            // Show full screen indicator or trigger cubit
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff0F172A),
                                ),
                              ),
                            );
                            
                            final success = await cubit.addSlot(
                              slotCode: slotCode.trim(),
                              sectionId: selectedSectionId!,
                              currentFloor: _currentFloor,
                            );
                            
                            if (context.mounted) {
                              Navigator.of(context).pop(); // remove loading indicator
                            }
                            
                            if (success) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Slot added successfully!'),
                                  backgroundColor: Color(0xff10B981),
                                ),
                              );
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to add slot.'),
                                  backgroundColor: Color(0xffEF4444),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Add",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            FloorSelectorWidget(
              selectedFloor: _currentFloor,
              onFloorSelected: _onFloorChanged,
            ),
            Expanded(
              child: BlocBuilder<ManageSlotsCubit, ManageSlotsState>(
                builder: (context, state) {
                  if (state is ManageSlotsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff0F172A),
                      ),
                    );
                  } else if (state is ManageSlotsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.manrope(color: Colors.red),
                      ),
                    );
                  } else if (state is ManageSlotsLoaded) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      children: state.slots
                          .map((slot) => SlotCardWidget(slot: slot))
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Admin Mode",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color(0xff64748B),
                ),
              ),
              Text(
                "Manage Slots",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3,
                  color: const Color(0xff0F172A),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showAddSlotDialog(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 20, 218, 86),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
