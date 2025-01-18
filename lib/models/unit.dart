class Unit {
  final String id;
  final String unitName;

  Unit({
    required this.id,
    required this.unitName,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['_id'],
      unitName: json['unit_name'],
    );
  }
}