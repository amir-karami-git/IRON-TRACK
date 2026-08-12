class Gym {
  final String name;

  Gym({required this.name});

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
