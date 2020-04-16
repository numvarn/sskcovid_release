import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Class for read/write User Profile json file
class ProfileFileProcess {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/profile.json');
  }

  Future<String> readProfile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents.toString();
    } catch (e) {
      return 'fail';
    }
  }

  Future<File> writeProfile(String data) async {
    final file = await _localFile;
    return file.writeAsString('$data');
  }
} //end class