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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xff10B981) : const Color(0xff0F172A);
    
    // Show a loading dialog first while we load sections
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: primaryColor,
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

    final dialogBg = isDark ? const Color(0xff1E293B) : Colors.white;
    final dialogTitleColor = isDark ? Colors.white : const Color(0xff0F172A);
    final fieldLabelColor = isDark ? const Color(0xff94A3B8) : const Color(0xff64748B);
    final inputBorderColor = isDark ? const Color(0xff334155) : const Color(0xffE2E8F0);
    final inputTextColor = isDark ? Colors.white : const Color(0xff0F172A);
    final inputHintColor = isDark ? const Color(0xff475569) : const Color(0xff94A3B8);
    final focusBorderColor = isDark ? const Color(0xff10B981) : const Color(0xff0F172A);
    final dropdownBg = isDark ? const Color(0xff1E293B) : Colors.white;
    final cancelButtonBorderColor = isDark ? const Color(0xff334155) : const Color(0xffE2E8F0);
    final cancelButtonTextColor = isDark ? const Color(0xff94A3B8) : const Color(0xff64748B);
    final addButtonBgColor = isDark ? const Color(0xff10B981) : const Color(0xff0F172A);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                "Add Parking Slot",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: dialogTitleColor,
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
                          color: fieldLabelColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "e.g. A-05",
                          hintStyle: GoogleFonts.manrope(
                            color: inputHintColor,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: focusBorderColor, width: 1.5),
                          ),
                        ),
                        style: GoogleFonts.manrope(color: inputTextColor),
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
                          color: fieldLabelColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedSectionId,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: focusBorderColor, width: 1.5),
                          ),
                        ),
                        dropdownColor: dropdownBg,
                        style: GoogleFonts.manrope(color: inputTextColor, fontSize: 16),
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
                            side: BorderSide(color: cancelButtonBorderColor),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: cancelButtonTextColor,
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
                              builder: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
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
                          backgroundColor: addButtonBgColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xff0F172A) : const Color(0xffF6F8F6);
    final primaryColor = isDark ? const Color(0xff10B981) : const Color(0xff0F172A);

    return Scaffold(
      backgroundColor: scaffoldBg,
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
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xff0F172A);
    final subtitleColor = isDark ? const Color(0xff94A3B8) : const Color(0xff64748B);
   // final plusBtnColor = isDark ? const Color(0xff10B981) : const Color.fromARGB(255, 20, 218, 86);

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
                  color: subtitleColor,
                ),
              ),
              Text(
                "Manage Slots",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3,
                  color: titleColor,
                ),
              ),
            ],
          ),
          // GestureDetector(
          //   onTap: () => _showAddSlotDialog(context),
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: plusBtnColor,
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Icon(
          //       Icons.add,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
