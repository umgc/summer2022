import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:usps_informed_delivery_backend/models/Logo.dart';
import 'barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usps_informed_delivery_backend/usps_address_verification.dart';
import 'api.dart';
import 'models/Code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USPS Informed Delivery App - Backend Features Testing',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const BackendPage(
          title: 'USPS Informed Delivery App - Backend Features'),
    );
  }
}

class BackendPage extends StatefulWidget {
  const BackendPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<BackendPage> createState() => _BackendPageState();
}

class _BackendPageState extends State<BackendPage> {
  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;
  CloudVisionApi? vision;
  BarcodeScannerApi? _barcodeScannerApi;
  //var fileName = 'assets/QRCode.PASSED.tdbank_id.jpeg';
  var fileName = 'assets/mail.test.03.png';
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      print("JSon: \n$json");

      //api = CloudApi(json);
      vision = CloudVisionApi();
      _barcodeScannerApi = BarcodeScannerApi();
    });
  }

  void _getImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.camera);
    print(PickedFile!.path);
    if (PickedFile != null) {
      _image = File(PickedFile.path);

      _imageBytes = _image!.readAsBytesSync();
      String a = base64.encode(_imageBytes!);
      var objMailResponse = await vision!.search(a);
      for (var address in objMailResponse.addresses) {
        address.validated = await UspsAddressVerification()
            .verifyAddressString(address.address);
      }
      setState(() {
        if (PickedFile != null) {
          _image = File(PickedFile.path);
          _imageBytes = _image!.readAsBytesSync();
          _imageName = _image!.path.split('/').last;
        } else {
          print('No image selected.');
        }
      });
    }
  }

  void _processImageWithOCR() async {
    print("inside processImageWithOCR\n");
    var image = await rootBundle.load(fileName);
    var buffer = image.buffer;
    var a = base64.encode(Uint8List.view(buffer));
    //print("Image: $image\nBuffer: $buffer\na: $a\n");
    //await vision!.searchImageForText(a);
    var objAddressList = await vision!.searchImageForText(a);
    for (var address in objAddressList) {
      address.validated =
          await UspsAddressVerification().verifyAddressString(address.address);
      print(address.toJson());
    }
    print("Exit ProcessImageWithOCR");
  }

  void _processImageForLogo() async {
    print("Inside processImageForLogo\n");
    var image = await rootBundle.load(fileName);
    var buffer = image.buffer;
    var a = base64.encode(Uint8List.view(buffer));
    //print("Image: $image\nBuffer: $buffer\na: $a\n");
    List<LogoObject> logos = await vision!.searchImageForLogo(a);
    for (var logo in logos) {
      print(logo.toJson());
    }
    print("Exit ProcessImageForLogo");
  }

  void _processBarcode() async {
    print("Inside process barcode\n");
    _barcodeScannerApi = BarcodeScannerApi();
    File img = await _barcodeScannerApi!.getImageFileFromAssets(fileName);
    _barcodeScannerApi!.setImageFromFile(img);

    List<codeObject> codes = await _barcodeScannerApi!.processImage();
    for (var code in codes) {
      print(code.toJson());
    }
    print("Exit ProcessBarcode");
  }

  void _processImage() async {
    print("Inside process image\n");
    var image = await rootBundle.load(fileName);
    var buffer = image.buffer;
    var a = base64.encode(Uint8List.view(buffer));
    //print("Image: $image\nBuffer: $buffer\na: $a\n");
    var objMr = await vision!.search(a);
    for (var address in objMr.addresses) {
      address.validated =
          await UspsAddressVerification().verifyAddressString(address.address);
    }
    _barcodeScannerApi = BarcodeScannerApi();
    File img = await _barcodeScannerApi!.getImageFileFromAssets(fileName);
    _barcodeScannerApi!.setImageFromFile(img);

    List<codeObject> codes = await _barcodeScannerApi!.processImage();
    for (final code in codes) {
      objMr.codes.add(code);
    }
    print(objMr.toJson());
    print("Exit ProcessImage (All Features)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Text(
                          style: TextStyle(fontSize: 20),
                          "Backend Testing",
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: Color.fromARGB(0, 255, 255, 1),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: Color.fromRGBO(228, 228, 228, 0.6),
                    child: ElevatedButton(
                      onPressed: _processImageWithOCR,
                      child: const Text(
                        "Vision OCR Text Search",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processImageForLogo,
                      child: const Text("Vision Logo Search",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processBarcode,
                      child: const Text("ML Kit  QR Codes/Barcodes Image Scan",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processImage,
                      child: const Text(
                          "All (OCR, Logo, & QR/Bar Codes) Image Processing",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _getImage,
                      child: const Text("Process Mail Image using Camera",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
