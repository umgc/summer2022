import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScannerView extends StatefulWidget {
  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text = "Please pick an image to scan";

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: const Icon(Icons.document_scanner),
              tooltip: 'Image Barcode scan',
              onPressed: () => {processImage()}),
          Text(_text ?? "No barcodes found")
        ],
      ),
    );
  }

  Future<void> processImage() async {
    if (!_canProcess) return;
    if (_isBusy) return;

    _isBusy = true;
    setState(() {
      _text = '';
      _image = null;
      _path = null;
    });

    final pickedFile =
        await _imagePicker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final path = pickedFile.path;

      setState(() {
        _image = File(path);
      });

      _path = path;
      InputImage inputImage = InputImage.fromFilePath(path);
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (inputImage.inputImageData?.size != null &&
          inputImage.inputImageData?.imageRotation != null) {
      } else {
        String text = 'Barcodes found: ${barcodes.length}\n\n';
        for (final barcode in barcodes) {
          text += 'Barcode: ${barcode.rawValue}\n\n';
        }
        print(text);

        setState(() {
          _text = text;
        });
      }
      _isBusy = false;

      if (mounted) {
        setState(() {});
      }
    }
  }
}
