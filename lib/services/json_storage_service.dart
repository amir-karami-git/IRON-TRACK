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
}
