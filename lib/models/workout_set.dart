/// The five equipment types a set can be logged under. Kept as plain
/// strings (not an enum) so they serialize to JSON without extra mapping.
class EquipmentType {
  static const String dumbbell = 'Dumbbell';
  static const String bar = 'Bar';
  static const String machine = 'Machine';
  static const String isometric = 'Isometric';
  static const String other = 'Other';

  static const List<String> all = [dumbbell, bar, machine, isometric, other];
}

class WorkoutSet {
  final String id;
  final String moveName;
  final String equipmentType;

  // Only set when equipmentType == Machine.
  final String? machineName;

  // Only set when equipmentType == Other.
  final String? otherDescription;

  // Only set when equipmentType is Dumbbell, Bar, or Machine.
  final double? weight;
  final String? weightUnit; // 'lb' or 'kg'
  final int? reps;

  // Only set when equipmentType == Isometric.
  final int? seconds;

  // Optional, available for every equipment type.
  final String? notes;

  WorkoutSet({
    required this.id,
    required this.moveName,
    required this.equipmentType,
    this.machineName,
    this.otherDescription,
    this.weight,
    this.weightUnit,
    this.reps,
    this.seconds,
    this.notes,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'],
      moveName: json['moveName'],
      equipmentType: json['equipmentType'],
      machineName: json['machineName'],
      otherDescription: json['otherDescription'],
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weightUnit'],
      reps: json['reps'],
      seconds: json['seconds'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moveName': moveName,
      'equipmentType': equipmentType,
      'machineName': machineName,
      'otherDescription': otherDescription,
      'weight': weight,
      'weightUnit': weightUnit,
      'reps': reps,
      'seconds': seconds,
      'notes': notes,
    };
  }
}
