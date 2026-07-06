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
  String _slotTypeFilter = 'all'; // 'all', 'normal', 'disabled'

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
              if (_userType == 'handicap') ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(label: "All Slots", filterValue: 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip(label: "Normal", filterValue: 'normal'),
                      const SizedBox(width: 8),
                      _buildFilterChip(label: "Special Needs", filterValue: 'disabled'),
                    ],
                  ),
                ),
              ],
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
                      
                      final type = slot.slotType.toLowerCase();
                      final isHandicap = type == 'handicap' || type == 'disabled' || type == 'accessible' || slot.isAccessible;
                      final isNormal = type == 'normal' || type.isEmpty;
                      
                      if (_userType == 'handicap') {
                        if (_slotTypeFilter == 'normal') {
                          return isCorrectFloor && isCorrectStatus && isNormal;
                        } else if (_slotTypeFilter == 'disabled') {
                          return isCorrectFloor && isCorrectStatus && isHandicap;
                        } else {
                          return isCorrectFloor && isCorrectStatus && (isNormal || isHandicap);
                        }
                      } else {
                        // Normal users see only normal slots
                        return isCorrectFloor && isCorrectStatus && isNormal;
                      }
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

  Widget _buildFilterChip({required String label, required String filterValue}) {
    final isSelected = _slotTypeFilter == filterValue;
    final activeColor = const Color(0xff00A24F);
    return GestureDetector(
      onTap: () {
        setState(() {
          _slotTypeFilter = filterValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : const Color(0xffF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? activeColor : const Color(0xff64748B),
          ),
        ),
      ),
    );
  }
}
