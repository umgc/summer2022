import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(
          title: 'USPS Informed Delivery App - Backend Features'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;
  CloudVisionApi? vision;

  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      print("JSon: \n$json");

      //api = CloudApi(json);
      vision = CloudVisionApi();
    });
  }

  void _getImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.camera);
    print(PickedFile!.path);

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

  void _processImageWithOCR() async {
    print("inside processImageWithOCR\n");
    var image = await rootBundle.load('assets/unnamed_3.jpg');
    var buffer = image.buffer;
    var a = base64.encode(Uint8List.view(buffer));
    print("Image: $image\nBuffer: $buffer\na: $a\n");
    await vision!.searchImageForText(a);
    print("Exit ProcessImageWithOCR");
  }

  void _processImageForLogo() async {
    print("Inside processImageForLogo\n");
    var image = await rootBundle.load('assets/logo_combined.jpg');
    var buffer = image.buffer;
    var a = base64.encode(Uint8List.view(buffer));
    print("Image: $image\nBuffer: $buffer\na: $a\n");
    await vision!.searchImageForLogo(a);
    print("Exit ProcessImageForLogo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processImageWithOCR,
                child: Text("Vision OCR Text Search"),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processImageForLogo,
                child: Text("Vision Logo Search"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Camera',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
