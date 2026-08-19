import 'workout_set.dart';

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final List<WorkoutSet> sets;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.sets,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      sets: (json['sets'] as List<dynamic>? ?? [])
          .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }

  /// Returns a copy with a different set list (used after adding/removing
  /// a set, since the model itself is immutable).
  Workout copyWithSets(List<WorkoutSet> newSets) {
    return Workout(id: id, name: name, date: date, sets: newSets);
  }
}
