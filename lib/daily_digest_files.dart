import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
//import 'package:json_annotation/json_annotation.dart';
import 'package:summer2022/models/MailResponse.dart';

part 'daily_digest_files.g.dart';

class DailyDigestFiles {

  late String directory;
  late List<MailResponse> files;

  DailyDigestFiles() {
    // Set the storage directory for the Daily Digest JSON files
    Directory dir = getApplicationDocumentsDirectory() as Directory;
    directory = dir.path;
    files = [];
  }

  List<MailResponse> getFiles() {
    return files;
  }

  // Load the last 7 days of Daily Digest JSON Files.
  void setFiles() {
    var formatter = DateFormat('yyy-MM-dd');

    // Create a list of files to load
    List<String> fileList = [];
    for (var i = 0; i < 7; i++) {
        DateTime date = DateTime.now().subtract(Duration(days:i));
        String formattedDate = formatter.format(date);
        String fileName = "'$formattedDate'.json";
        fileList.add(fileName);
    }

    for (var jsonFile in fileList) {
      MailResponse? dailyDigest = readFromFile(jsonFile);
      if (dailyDigest != null) {
        files.add(dailyDigest);
      }
    }
  }

  // Load a Daily Digest JSON File from a specific date.
  MailResponse? getDailyDigestByDate(String date) {
    String fileName = "'$date'.json";
    MailResponse? dailyDigest = readFromFile(fileName);
    return dailyDigest;
  }

  // Write a Daily Digest JSON object to a file.
  void writeToFile(MailResponse digestObject, String date) {
    String fileName = "'$date'.json";
    String filePath = "'$this.directory'/'$fileName'";
    File file = File(filePath);
    file.createSync();
    file.writeAsStringSync(digestObject.toString());
  }

  // Read a Daily Digest JSON file.
  MailResponse? readFromFile(String fileName) {
    String filePath = "'$this.directory'/'$fileName'";
    File jsonFile = File(filePath);
    bool fileExists = jsonFile.existsSync();
    MailResponse dailyDigest;
    if (fileExists) {
      String contents = jsonFile.readAsStringSync();
      dailyDigest = MailResponse.fromJson(jsonDecode(contents));
      return dailyDigest;
    } else {
      return null;
    }
    
  }
}