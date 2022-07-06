// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  test('Scanner must not recognize QR Code', () async {
    var image = await rootBundle.load('assets/QRCode.FAILED.XFINITY.jpeg');
    var buffer = image.buffer;
    var i = await decodeImageFromList(buffer.asUint8List());
    InputImageData iid = InputImageData(
      size: Size(i.width.toDouble(), i.height.toDouble()),
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.nv21,
      planeData: [],
    );

    InputImage img =
        InputImage.fromBytes(bytes: buffer.asUint8List(), inputImageData: iid);

    const MethodChannel('google_mlkit_barcode_scanning')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'vision#startBarcodeScanner') {
        return <codeObject>[];
      }
      return null;
    });

    BarcodeScannerApi scanner = BarcodeScannerApi();
    List<codeObject> codes = await scanner.processImage(img);
    expect(codes.length, 0);
  });

  test('Scanner must not recognize QR Code', () async {
    var image = await rootBundle.load('assets/QRCode.PASSED.tdbank_id.jpeg');
    var buffer = image.buffer;
    var i = await decodeImageFromList(buffer.asUint8List());
    InputImageData iid = InputImageData(
      size: Size(i.width.toDouble(), i.height.toDouble()),
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.nv21,
      planeData: [],
    );

    InputImage img =
        InputImage.fromBytes(bytes: buffer.asUint8List(), inputImageData: iid);

    const MethodChannel('google_mlkit_barcode_scanning')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'vision#startBarcodeScanner') {
        return <codeObject>[];
      }
      return null;
    });

    BarcodeScannerApi scanner = BarcodeScannerApi();
    List<codeObject> codes = await scanner.processImage(img);
    expect(codes.length, 1);
  });
}
