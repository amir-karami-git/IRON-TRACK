import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/gyms.json');
  }

  static Future<void> saveFile(List<Map<String, dynamic>> gyms) async {
    final file = await getFile();
    final jsonString = jsonEncode(gyms);
    await file.writeAsString(jsonString);
  }

  static Future<List<Map<String, dynamic>>> loadFile() async {
    final file = await getFile();
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonString);
    final List<Map<String, dynamic>> gyms = data.cast<Map<String, dynamic>>();
    return gyms;
  }
}
