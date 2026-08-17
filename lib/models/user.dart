class User {
  final String username;
  final String password; // stored as a hash, never plain text

  User({required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
