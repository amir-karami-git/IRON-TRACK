class Gym {
  final String id;
  final String name;

  Gym({required this.id, required this.name});

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
