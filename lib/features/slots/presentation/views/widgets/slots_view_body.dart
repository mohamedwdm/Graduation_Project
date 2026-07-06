import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/greeting_header.dart';
import '../../../../auth/data/datasources/auth_local_datasource.dart';
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
  int _selectedFloor = 1;
  String _userName = 'User';
  String? _userType;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await sl<AuthLocalDataSource>().getCachedUser();
      if (user != null && mounted) {
        setState(() {
          _userName = user.name;
          _userType = user.userType;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              GreetingHeader(userName: _userName),
              const SizedBox(height: 6),
              FloorSelector(
                selectedFloor: _selectedFloor - 1,
                onFloorSelected: (index) {
                  final floorNum = index + 1;
                  if (_selectedFloor != floorNum) {
                    setState(() {
                      _selectedFloor = floorNum;
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
                    final filteredSlots = state.slots.where((slot) {
                      final isCorrectFloor = slot.floor == _selectedFloor;
                      final isCorrectStatus = slot.status == 'available' || slot.isAvailable;
                      final isAccessible = slot.isAccessible || slot.slotType == 'handicap';
                      
                      if (isAccessible && _userType != 'handicap') {
                        return false;
                      }
                      
                      return isCorrectFloor && isCorrectStatus;
                    }).toList();

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
