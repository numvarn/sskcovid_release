import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Class for read/write Authentications json file
class AuthenFileProcess {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/authen.json');
  }

  Future<String> readToken() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents.toString();
    } catch (e) {
      return 'fail';
    }
  }

  Future<File> writeToken(String data) async {
    final file = await _localFile;
    return file.writeAsString('$data');
  }
} //end class