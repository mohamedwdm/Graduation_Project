import 'package:flutter/material.dart';
import '../../domain/entities/slot_entity.dart';
import 'slot_card.dart';

class SlotGrid extends StatelessWidget {
  final List<SlotEntity> slots;

  const SlotGrid({super.key, required this.slots});

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const _EmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic crossAxisCount based on screen width
        int crossAxisCount = (constraints.maxWidth / 160).floor().clamp(2, 4);
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            return SlotCard(slot: slots[index]);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_parking,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No slots available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try checking another floor or wait for updates.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
