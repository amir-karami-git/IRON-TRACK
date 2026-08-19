import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Generic JSON file storage. Pass in a file name (e.g. "gyms.json" or
/// "users.json") so the same service can back multiple local "collections".
class JsonStorageService {
  static Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<void> saveFile(
    String fileName,
    List<Map<String, dynamic>> data,
  ) async {
    final file = await _getFile(fileName);
    final jsonString = jsonEncode(data);
    await file.writeAsString(jsonString);
  }

  static Future<List<Map<String, dynamic>>> loadFile(String fileName) async {
    final file = await _getFile(fileName);

    if (!await file.exists()) {
      return [];
    }

    final jsonString = await file.readAsString();

    if (jsonString.trim().isEmpty) {
      return [];
    }

    final List<dynamic> data = jsonDecode(jsonString);
    return data.cast<Map<String, dynamic>>();
  }

  /// Deletes the file entirely (used when a user deletes their account and
  /// we need to wipe their personal data). Safe to call even if the file
  /// was never created.
  static Future<void> deleteFile(String fileName) async {
    final file = await _getFile(fileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes every file whose name starts with [prefix]. Used to wipe all
  /// of a user's per-gym workout files in one go when they delete their
  /// account, without needing to know each gym id up front.
  static Future<void> deleteFilesWithPrefix(String prefix) async {
    final directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) return;

    await for (final entity in directory.list()) {
      if (entity is File) {
        final name = entity.uri.pathSegments.last;
        if (name.startsWith(prefix)) {
          await entity.delete();
        }
      }
    }
  }
}
