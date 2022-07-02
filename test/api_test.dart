import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usps_informed_delivery_backend/api.dart';
import 'package:usps_informed_delivery_backend/credentials_provider.dart';
import 'package:usps_informed_delivery_backend/models/Address.dart';
import 'package:usps_informed_delivery_backend/models/Logo.dart';
import 'package:usps_informed_delivery_backend/models/MailResponse.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;
  group("CloudVision Tests", () {
    test("Cloud Vision Credentials Test - Credentials File loaded", () async {
      String error = '';
      try {
        await rootBundle.loadString('assets/credentials.json');
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });
    // test("Cloud Vision Credentials Test - Credentials File loaded", () async {
    //   CredentialsProvider cP = CredentialsProvider();
    //   var errorMsg = '';
    //   await cP.client.asStream((element) => print(element.credentials.toString();
    //   expect(s, false);
    // });
    test(
        'Cloud Vision Image Information Retrieval Test - Receives Text from image',
        () async {
      CloudVisionApi vision = CloudVisionApi();
      var image = await rootBundle.load('assets/mail.06.jpg');
      var buffer = image.buffer;
      var a = base64.encode(Uint8List.view(buffer));
      //print("Image: $image\nBuffer: $buffer\na: $a\n");
      List<AddressObject> addresses = await vision.searchImageForText(a);
      //print(s.toJson());
      expect(addresses[0].getName, 'GEICO.');
      expect(addresses[0].getAddress, '2563 Forest Dr; Annapolis, MD 21401');
      expect(addresses[1].getName, 'Stanley De Jesus');
      expect(addresses[1].getAddress,
          '7793 Montgomery Mews Ct; Severn MD 21144-1245');
    });
    test('Cloud Vision Logo Detection Test - Receives Logo information',
        () async {
      CloudVisionApi vision = CloudVisionApi();
      var image = await rootBundle.load('assets/mail.06.jpg');
      var buffer = image.buffer;
      var a = base64.encode(Uint8List.view(buffer));
      //print("Image: $image\nBuffer: $buffer\na: $a\n");
      List<LogoObject> logos = await vision.searchImageForLogo(a);
      //print(s.toJson());
      expect(logos[0].getName, 'GEICO');
    });
    test(
        'Cloud Vision Daily Digest Test- For each image, the application uses the api to retrieve information and consolidates (JSON).',
        () async {
      CloudVisionApi vision = CloudVisionApi();
      var image = await rootBundle.load('assets/mail.06.jpg');
      var buffer = image.buffer;
      var a = base64.encode(Uint8List.view(buffer));
      //print("Image: $image\nBuffer: $buffer\na: $a\n");
      MailResponse mail = await vision.search(a);
      //print(mail.toJson().toString());
      expect(mail.toJson().toString(),
          '{addresses: [{type: sender, name: GEICO., address: 2563 Forest Dr; Annapolis, MD 21401, validated: false}, {type: recipient, name: Stanley De Jesus, address: 7793 Montgomery Mews Ct; Severn MD 21144-1245, validated: false}], logos: [{name: GEICO}, {name: GEICO}]}');
    });
    test('Cloud Vision Image Verification illegible- Returns empty object',
        () async {
      CloudVisionApi vision = CloudVisionApi();
      var image = await rootBundle.load('assets/horusx.jpg');
      var buffer = image.buffer;
      var a = base64.encode(Uint8List.view(buffer));
      //print("Image: $image\nBuffer: $buffer\na: $a\n");
      MailResponse mail = await vision.search(a);
      //print(mail.toJson().toString());
      expect(mail.addresses.length, 0);
      expect(mail.logos.length, 0);
      //expect(mail.logos[0].name, 'None');
    });
  });
  // group("Camera Tests", () {
  //   test("Camera Test 1 - ", () async {
  //     String error = '';
  //     final picker = ImagePicker();
  //     final LostDataResponse response = await picker.retrieveLostData();
  //     if (response.isEmpty) {
  //       return;
  //     }
  //     if (response.files != null) {
  //       print(response.file!.name + "/" + response.file!.path);
  //     }
  //   });
  // });
}
