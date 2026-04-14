import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/greeting_header.dart';
import '../../manager/slots_cubit/slots_cubit.dart';
import '../../manager/slots_cubit/slots_state.dart';
import 'floor_selector.dart';
import 'slot_item_card.dart';

class SlotsViewBody extends StatefulWidget {
  const SlotsViewBody({super.key});

  @override
  State<SlotsViewBody> createState() => _SlotsViewBodyState();
}

class _SlotsViewBodyState extends State<SlotsViewBody> {
  int _selectedFloor = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const GreetingHeader(userName: 'User'),
              const SizedBox(height: 6),
              FloorSelector(
                selectedFloor: _selectedFloor,
                onFloorSelected: (index) {
                  if (_selectedFloor != index) {
                    setState(() {
                      _selectedFloor = index;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              BlocBuilder<SlotsCubit, SlotsState>(
                builder: (context, state) {
                  if (state is SlotsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF0F172A)),
                      ),
                    );
                  } else if (state is SlotsError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  } else if (state is SlotsLoaded) {
                    final filteredSlots = state.slots
                        .where((slot) => slot.floor == _selectedFloor)
                        .toList();

                    if (filteredSlots.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No slots available on this floor.',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              color: Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: filteredSlots.map(
                        (slot) => SlotItemCard(slot: slot),
                      ).toList(),
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
