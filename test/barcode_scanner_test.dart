// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Scanner must return QR Code link', () async {
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];

    File img = await barcodeScanner
        .getImageFileFromAssets('assets/QRCode.PASSED.tdbank_id.jpeg');
    barcodeScanner.setImageFromFile(img);
    codes = await barcodeScanner.processImage();

    expect(codes[0].info, "https://qrco.de/bczuEB");
  });

  test('Scanner must not recognize QR Code', () async {
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];

    File img = await barcodeScanner
        .getImageFileFromAssets("assets/QRCode.FAILED.XFINITY.jpeg");
    barcodeScanner.setImageFromFile(img);
    codes = await barcodeScanner.processImage();

    expect(codes[0].info, "");
  });
}
