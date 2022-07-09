import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  // setUpAll(() {
  //   const channel = MethodChannel(
  //     'plugins.flutter.io/path_provider_macos',
  //   );
  //   channel.setMockMethodCallHandler((MethodCall methodCall) async {
  //     switch (methodCall.method) {
  //       case 'getTemporaryDirectory':
  //         return "test/data";
  //       default:
  //     }
  //   });
  // });
  // group("QR/Barcode Test", () {
  //   test('Scanner must recognize QR Code', () async {
  //     const MethodChannel('google_mlkit_barcode_scanning')
  //         .setMockMethodCallHandler((MethodCall methodCall) async {
  //       if (methodCall.method == 'vision#startBarcodeScanner') {
  //         return <codeObject>[];
  //       }
  //       return null;
  //     });

  //     BarcodeScannerApi scanner = BarcodeScannerApi();
  //     File f = await scanner.getImageFileFromAssets('assets/mail.test.03.png');
  //     InputImage img = InputImage.fromFile(f);
  //     List<codeObject> codes = await scanner.processImage(img);
  //     expect(codes.length, 1);
  //   });
  //   test('Scanner must not recognize QR Code', () async {
  //     const MethodChannel('google_mlkit_barcode_scanning')
  //         .setMockMethodCallHandler((MethodCall methodCall) async {
  //       if (methodCall.method == 'vision#startBarcodeScanner') {
  //         return <codeObject>[];
  //       }
  //       return null;
  //     });

  //     BarcodeScannerApi scanner = BarcodeScannerApi();
  //     File f = await scanner.getImageFileFromAssets('assets/mail.test.02.png');
  //     print(f.path);
  //     InputImage img = InputImage.fromFile(f);
  //     List<codeObject> codes = await scanner.processImage(img);
  //     expect(codes.length, 0);
  //   });
  // });
}
