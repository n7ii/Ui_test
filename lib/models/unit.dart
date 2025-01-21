// models/unit.dart
class Unit {
  final String id;
  final String unitName;
  final int unitId;

  Unit({
    required this.id,
    required this.unitName,
    required this.unitId,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['_id'] ?? '',
      unitName: json['unit_name'] ?? '',
      unitId: json['unit_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'unit_name': unitName,
      'unit_id': unitId,
    };
  }

  // Add these methods for proper object comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          unitId == other.unitId;

  @override
  int get hashCode => id.hashCode ^ unitId.hashCode;
}