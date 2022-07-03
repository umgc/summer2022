// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:test/test.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() {
  test('Scanner must return QR Code link', () {
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];
    File img = File("assets/QRCode.PASSED.tdbank_id.jpeg");

    barcodeScanner.setImageFromFile(img);
    codes = barcodeScanner.processImage() as List<codeObject>;

    expect(codes[0].info, "https://qrco.de/bczuEB");
  });

  test('Scanner must not recognize QR Code', () {
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];
    File img = File("");

    barcodeScanner.setImageFromFile(img);
    codes = barcodeScanner.processImage() as List<codeObject>;

    expect(codes[0].info, "");
  });
}
