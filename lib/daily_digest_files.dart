import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_digest_files.g.dart';

/*
The following objects allow the Daily Digest JSON files to be serialized and deserialized.
The comments in the MailObject class describes how the code for the nested classes is implemented.
*/

// An annotation for the code generator to know that this class needs the
// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class MailObject {
  final String type;
  final String name;
  final String address;
  final String validated;

  MailObject(this.type, this.name, this.address, this.validated);

  // A necessary factory constructor for creating a new MailObject instance
  // from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  // The constructor is named after the source class, in this case, MailObject.
  factory MailObject.fromJson(Map<String, dynamic> json) => _$MailObjectFromJson(json);

  // `toJson` is the convention for a class to declare support for serialization
  // to JSON. The implementation simply calls the private, generated
  // helper method `_$MailObjectToJson`
  Map<String, dynamic> toJson() => _$MailObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DescriptionObject {
  final String name;

  DescriptionObject(this.name);

  factory DescriptionObject.fromJson(Map<String, dynamic> json) => _$DescriptionObjectFromJson(json);
  Map<String, dynamic> toJson() => _$DescriptionObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LogoObject {
  final DescriptionObject description;

  LogoObject(this.description);

  factory LogoObject.fromJson(Map<String, dynamic> json) => _$LogoObjectFromJson(json);
  Map<String, dynamic> toJson() => _$LogoObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CodeObject {
  final String codeType;
  final String link;

  CodeObject(this.codeType, this.link);

  factory CodeObject.fromJson(Map<String, dynamic> json) => _$CodeObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CodeObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DailyDigestFile {
  final List<MailObject> mailObject;
  final LogoObject logoObject;
  final CodeObject codeObject;

  DailyDigestFile(this.mailObject, this.logoObject, this.codeObject);

  factory DailyDigestFile.fromJson(Map<String, dynamic> json) => _$DailyDigestFileFromJson(json);
  Map<String, dynamic> toJson() => _$DailyDigestFileToJson(this);
}

class DailyDigestFiles {

  String directory;
  List<DailyDigestFile> files;

  DailyDigestFiles(this.directory, this.files) {
    // Set the storage directory for the Daily Digest JSON files
    Directory dir = getApplicationDocumentsDirectory() as Directory;
    directory = dir.path;
  }

  List<DailyDigestFile> getFiles() {
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
      DailyDigestFile? dailyDigest = readFromFile(jsonFile);
      if (dailyDigest != null) {
        files.add(dailyDigest);
      }
    }
  }

  // Load a Daily Digest JSON File from a specific date.
  DailyDigestFile? getDailyDigestByDate(String date) {
    String fileName = "'$date'.json";
    DailyDigestFile? dailyDigest = readFromFile(fileName);
    return dailyDigest;
  }

  // Write a Daily Digest JSON object to a file.
  void writeToFile(DailyDigestFile digestObject, String date) {
    String fileName = "'$date'.json";
    String filePath = "'$this.directory'/'$fileName'";
    File file = File(filePath);
    file.createSync();
    file.writeAsStringSync(digestObject.toString());
  }

  // Read a Daily Digest JSON file.
  DailyDigestFile? readFromFile(String fileName) {
    String filePath = "'$this.directory'/'$fileName'";
    File jsonFile = File(filePath);
    bool fileExists = jsonFile.existsSync();
    DailyDigestFile dailyDigest;
    if (fileExists) {
      String contents = jsonFile.readAsStringSync();
      dailyDigest = DailyDigestFile.fromJson(jsonDecode(contents));
      return dailyDigest;
    } else {
      return null;
    }
    
  }

}