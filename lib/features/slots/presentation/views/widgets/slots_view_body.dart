import 'package:flutter/material.dart';
import 'package:go2car/features/home/presentation/views/widgets/home_header_section.dart';
import 'package:go2car/features/slots/data/models/slot_model.dart';
import 'package:go2car/features/slots/data/repos/slots_repo.dart';
import 'package:go2car/features/slots/data/repos/slots_repo_impl.dart';

import 'floor_selector.dart';
import 'slot_item_card.dart';

class SlotsViewBody extends StatefulWidget {
  const SlotsViewBody({super.key});

  @override
  State<SlotsViewBody> createState() => _SlotsViewBodyState();
}

class _SlotsViewBodyState extends State<SlotsViewBody> {
  int _selectedFloor = 0;
  bool _isLoading = false;
  List<SlotModel> _currentSlots = [];

  // Instantiate the repository
  final SlotsRepo _slotsRepo = SlotsRepoImpl();

  @override
  void initState() {
    super.initState();
    _fetchSlotsForCurrentFloor();
  }

  Future<void> _fetchSlotsForCurrentFloor() async {
    setState(() {
      _isLoading = true;
    });

    final slots = await _slotsRepo.fetchSlotsByFloor(
      floorIndex: _selectedFloor,
    );

    setState(() {
      _currentSlots = slots;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const HomeHeaderSection(),
              const SizedBox(height: 6),
              FloorSelector(
                selectedFloor: _selectedFloor,
                onFloorSelected: (index) {
                  if (_selectedFloor != index) {
                    setState(() {
                      _selectedFloor = index;
                    });
                    _fetchSlotsForCurrentFloor();
                  }
                },
              ),
              const SizedBox(height: 14),

              // Handle Loading and Empty States dynamically!
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF0F172A)),
                  ),
                )
              else if (_currentSlots.isEmpty)
                const Padding(
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
                )
              else
                ..._currentSlots.map(
                  (slotModel) => SlotItemCard(slotModel: slotModel),
                ),

              // extra spacing to make sure bottom items are fully reachable
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
