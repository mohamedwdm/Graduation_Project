import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../manager/manage_slots_cubit/manage_slots_cubit.dart';
import '../manager/manage_slots_cubit/manage_slots_state.dart';
import '../widgets/slot_card_widget.dart';
import '../widgets/floor_selector_widget.dart';
import '../widgets/add_slot_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8F6),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
            Positioned(
              bottom: 24,
              right: 16,
              child: AddSlotButton(
                onPressed: () {
                  // TODO: Implement add slot logic
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
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xffE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xff0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
