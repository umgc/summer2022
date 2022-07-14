import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:summer2022/daily_digest_files.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// We have to set up a fake PathProviderPlatform in order to use getApplicationDocumentsPath in unit tests
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    String current = io.Directory.current.path;
    return "$current/test/testStorage";
  }
}

void main() async {
  var jsonList = [{"addresses": [{"type": "sender", "name": "GEICO", "address": "2563 Forest Dr; Annapolis, MD 21401", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "GEICO"}, {"name": "GEICO"}], "codes": [{"type": "url", "info": "https://geico.com"}]},
                  {"addresses": [{"type": "sender", "name": "Bed Bath and Beyond", "address": "650 Liberty Avenue Union; NJ 07083", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "Bed Bath and Beyond"}], "codes": [{"type": "url", "info": "https://bedbathandbeyond.com"}]},
                  {"addresses": [{"type": "sender", "name": "Best Buy", "address": "7601 Penn Ave. S; Richfield, MN 55423", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "Best Buy"}], "codes": []},
                  {"addresses": [{"type": "sender", "name": "Ben Carlson", "address": "15300 Poplar Hill; Accokeek, MD 20607-3504", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [], "codes": []},
                  {"addresses": [{"type": "sender", "name": "Home Depot", "address": "2455 Paces Ferry Rd. Nw; Atlanta, GA, 30339", "validated": true}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "Home Depot"}], "codes": [{"type": "url", "info": "https://homedepot.com"}]},
                  {"addresses": [{"type": "sender", "name": "Katie Johnson", "address": "4600  Pebbleshire; Waldorf, MD 20602-4108", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [], "codes": []},
                  {"addresses": [{"type": "sender", "name": "BGE", "address": "1068 N. Front St.; Baltimore, MD 21202", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "BGE"}, {"name": "BGE"}], "codes": [{"type": "url", "info": "https://bge.com"}]}];

  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;
  MailResponse mail = MailResponse.fromJson({"addresses": [{"type": "sender", "name": "GEICO", "address": "2563 Forest Dr; Annapolis, MD 21401", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "GEICO"}, {"name": "GEICO"}], "codes": [{"type": "url", "info": "https://geico.com"}]});

  void generateTestFiles() async {
    // Create files so we can test loading files for the past week
    var formatter = DateFormat('yyy-MM-dd');
    
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    DateTime dateNow = DateTime.now();

    for (var i = 0; i < 7; i++) {
        DateTime date = dateNow.subtract(Duration(days:i));
        String formattedDate = formatter.format(date);
        String fileName = "$formattedDate.json";
        String filePath = "$path/$fileName";
        io.File file = io.File(filePath);
        file.createSync();
        file.writeAsStringSync(jsonEncode(jsonList[i]));
    }
  }

  group("Daily Digest Files Tests", () {
    
    test("Write to File", () async {
      String error = '';
      DailyDigestFiles handleFiles = DailyDigestFiles();
      try {
        handleFiles.writeToFile(mail, '2022-07-13');
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');

      // Verify that the correct information was written to the file
      // The file write_to_file_test.json is the expected file output
      try {
        final directory = await getApplicationDocumentsDirectory();
        String path = directory.path;
        String filePath = "$path/2022-07-13.json";
        io.File jsonFile = io.File(filePath);
        String contents = await jsonFile.readAsString();

        String testFilePath = "$path/../data/write_to_file_test.json";
        io.File testFile = io.File(testFilePath);
        String testContents = await testFile.readAsString();

        expect(testContents != "", true);
        expect(contents, testContents);
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read From File", () async {
      String error = '';
      DailyDigestFiles handleFiles = DailyDigestFiles();
      try {
        MailResponse? dailyDigest = await handleFiles.readFromFile('2020-06-01.json');
        expect(json.encode(dailyDigest), json.encode(mail));
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Get Daily Digest by Date", () async {
      String error = '';
      DailyDigestFiles handleFiles = DailyDigestFiles();
      try {
        MailResponse? dailyDigest = await handleFiles.getDailyDigestByDate('2020-06-01');
        expect(json.encode(dailyDigest), json.encode(mail));
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Load Last Week of Files", () async {
      generateTestFiles();
      String error = '';
      DailyDigestFiles handleFiles = DailyDigestFiles();
      try {
        // Load the past 7 days of files
        await handleFiles.setFiles();
        // Get the list of MailResponses
        List<MailResponse> allMail = handleFiles.getFiles();
        for (var i = 0; i < 7; i++) {
          expect(json.encode(allMail[i]), json.encode(jsonList[i]));
        }
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

  });

}