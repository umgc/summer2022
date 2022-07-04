// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  test('Scanner must return QR Code link', () async {
    const MethodChannel('google_mlkit_barcode_scanning')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'vision#startBarcodeScanner') {
        print(1);
        return <codeObject>[];
      }
      return null;
    });
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];

    File img = await barcodeScanner
        .getImageFileFromAssets('assets/QRCode.PASSED.tdbank_id.jpeg');
    barcodeScanner.setImageFromFile(img);
    codes = await barcodeScanner.processImage();

    expect(codes[0].info, "https://qrco.de/bczuEB");
  });

  test('Scanner must not recognize QR Code', () async {
    const MethodChannel('google_mlkit_barcode_scanning')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'vision#startBarcodeScanner') {
        print(2);
        return <codeObject>[];
      }
      return null;
    });
    final barcodeScanner = BarcodeScannerApi();
    List<codeObject> codes = [];

    File img = await barcodeScanner
        .getImageFileFromAssets("assets/QRCode.FAILED.XFINITY.jpeg");
    barcodeScanner.setImageFromFile(img);
    codes = await barcodeScanner.processImage();

    expect(codes[0].info, "");
  });
}
