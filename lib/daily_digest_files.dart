import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import './models/MailResponse.dart';

class DailyDigestFiles {
  late List<MailResponse> files;

  DailyDigestFiles() {
    // Set the storage directory for the Daily Digest JSON files
    files = [];
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderIOS.registerWith();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getPath() async {
    final path = await _localPath;
    return path;
  }

  List<MailResponse> getFiles() {
    return files;
  }

  // Load the last 7 days of Daily Digest JSON Files.
  Future<void> setFiles() async {
    var formatter = DateFormat('yyy-MM-dd');
    DateTime dateNow = DateTime.now();
    // Create a list of files to load
    List<String> fileList = [];
    for (var i = 0; i < 7; i++) {
      DateTime date = dateNow.subtract(Duration(days: i));
      String formattedDate = formatter.format(date);
      String fileName = "$formattedDate.json";
      fileList.add(fileName);
    }

    for (String jsonFile in fileList) {
      MailResponse? dailyDigest = await readFromFile(jsonFile);
      if (dailyDigest != null) {
        files.add(dailyDigest);
      }
    }
  }

  // Load a Daily Digest JSON File from a specific date.
  Future<MailResponse?> getDailyDigestByDate(String date) async {
    String fileName = "$date.json";
    MailResponse? dailyDigest = await readFromFile(fileName);
    return dailyDigest;
  }

  // Write a Daily Digest JSON object to a file.
  void writeToFile(MailResponse digestObject, String date) async {
    String fileName = "$date.json";
    final path = await _localPath;
    String filePath = "$path/$fileName";
    File file = File(filePath);
    file.createSync();
    file.writeAsStringSync(jsonEncode(digestObject));
  }

  // Read a Daily Digest JSON file.
  Future<MailResponse?> readFromFile(String fileName) async {
    final path = await _localPath;
    String filePath = "$path/$fileName";
    File jsonFile = File(filePath);
    bool fileExists = jsonFile.existsSync();
    MailResponse dailyDigest;
    if (fileExists) {
      String contents = await jsonFile.readAsString();
      dailyDigest = MailResponse.fromJson(jsonDecode(contents));
      return dailyDigest;
    } else {
      return null;
    }
  }
}
