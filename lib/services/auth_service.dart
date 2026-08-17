import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user.dart';
import 'json_storage_service.dart';

/// Handles account creation and login, persisted locally in users.json
/// via JsonStorageService. Passwords are hashed (SHA-256) before they're
/// ever written to disk.
class AuthService {
  static const String _usersFile = 'users.json';

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static Future<List<User>> _loadUsers() async {
    final data = await JsonStorageService.loadFile(_usersFile);
    return data.map((u) => User.fromJson(u)).toList();
  }

  static Future<void> _saveUsers(List<User> users) async {
    final data = users.map((u) => u.toJson()).toList();
    await JsonStorageService.saveFile(_usersFile, data);
  }

  /// Creates a new account. Returns null on success, or an error message.
  static Future<String?> signUp(String username, String password) async {
    final trimmedUsername = username.trim();

    if (trimmedUsername.isEmpty || password.isEmpty) {
      return "Username and password can't be empty";
    }

    if (password.length < 4) {
      return "Password must be at least 4 characters";
    }

    final users = await _loadUsers();

    final alreadyExists = users.any(
      (u) => u.username.toLowerCase() == trimmedUsername.toLowerCase(),
    );

    if (alreadyExists) {
      return "That username is already taken";
    }

    users.add(
      User(username: trimmedUsername, password: _hashPassword(password)),
    );
    await _saveUsers(users);

    return null;
  }

  /// Logs in an existing account. Returns null on success, or an error message.
  static Future<String?> logIn(String username, String password) async {
    final users = await _loadUsers();
    final hashedAttempt = _hashPassword(password);
    final trimmedUsername = username.trim().toLowerCase();

    final matches = users.where(
      (u) =>
          u.username.toLowerCase() == trimmedUsername &&
          u.password == hashedAttempt,
    );

    if (matches.isEmpty) {
      return "Incorrect username or password";
    }

    return null;
  }
}
