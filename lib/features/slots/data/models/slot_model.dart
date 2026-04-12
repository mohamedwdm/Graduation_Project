class SlotModel {
  final String slotId;
  final String locationNote;
  final bool isAvailable;
  final bool hasEvCharging;
  final bool isAccessible;
  final int floorIndex;

  const SlotModel({
    required this.slotId,
    required this.locationNote,
    this.isAvailable = true,
    this.hasEvCharging = false,
    this.isAccessible = false,
    required this.floorIndex,
  });
}
