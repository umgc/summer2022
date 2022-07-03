import 'dart:io';

import './models/Code.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeScannerApi {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  String? _path;
  InputImage? inputImage;
  bool _isBusy = false;

  void setImageFromPath(String path) {
    inputImage = InputImage.fromFilePath(path);
  }

  void setImageFromFile(File img) {
    inputImage = InputImage.fromFile(img);
  }

  Future<List<codeObject>> processImage() async {
    List<codeObject> codes = [];

    if (_isBusy) return codes;

    _isBusy = true;

    if (_path != null) {
      final barcodes = await _barcodeScanner.processImage(inputImage!);
      if (inputImage!.inputImageData?.size != null &&
          inputImage!.inputImageData?.imageRotation != null) {
      } else {
        for (final barcode in barcodes) {
          print(barcode);
          codes.add(codeObject(type: '', info: barcode.rawValue));
        }
      }
      _isBusy = false;
    }

    return codes;
  }
}
