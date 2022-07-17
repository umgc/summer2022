import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:summer2022/main_menu.dart';
import 'package:summer2022/usps_address_verification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:summer2022/api.dart';
import './models/MailResponse.dart';
import 'barcode_scanner.dart';
import 'models/Arguments.dart';
import 'models/Code.dart';
import 'models/Digest.dart';
import 'models/Logo.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MailWidget extends StatefulWidget {
  final Digest digest;

  const MailWidget({required this.digest});

  @override
  State<MailWidget> createState() {
    return _MailWidgetState();
  }
}

class _MailWidgetState extends State<MailWidget> {
  int attachmentIndex = 0;
  CloudVisionApi vision = CloudVisionApi();
  BarcodeScannerApi? _barcodeScannerApi;
  String filePath = '';
  String imagePath =
      '/storage/emulated/0/Android/data/com.example.summer2022/files';

  deleteImageFiles() async {
    Directory? directory = await getExternalStorageDirectory();
    Directory? directory2 = await getTemporaryDirectory();
    var files = directory?.listSync(recursive: false, followLinks: false);
    var files2 = directory2.listSync(recursive: false, followLinks: false);
    for (int x = 0; x < files!.length; x++) {
      print("Delete in Extern: " + files[x].path);
      files[x].delete();
    }
    for (int x = 0; x < files2.length; x++) {
      print("Delete: " + files2[x].path);
      files[x].delete();
    }
  }

  void _processImageForLogo(String imagePath) async {
    print("Inside processImageForLogo\n");
    // var image = await rootBundle.load('assets/$fileName');
    var image = File(imagePath);
    var buffer = image.readAsBytesSync();
    var a = base64.encode(buffer);
    //print("Image: $image\nBuffer: $buffer\na: $a\n");
    List<LogoObject> logos = await vision.searchImageForLogo(a);
    var output = '';
    for (var logo in logos) {
      output += logo.toJson().toString() + "\n";
    }
    print(output);
    print("Exit ProcessImageForLogo");
  }

  void _processBarcode() async {
    print("Inside process barcode\n");
    _barcodeScannerApi = BarcodeScannerApi();
    var fLoc = filePath;
    print(fLoc);
    File? img = await _barcodeScannerApi?.getImageFileFromAssets(filePath);

    // await _barcodeScannerApi!.getImageFileFromAssets('assets/$fileName');
    _barcodeScannerApi!.setImageFromFile(img!);

    List<codeObject> codes = await _barcodeScannerApi!.processImage();
    var output = '';
    for (var code in codes) {
      output += code.toJson().toString();
    }
    print(output);
    print("Exit ProcessBarcode");
  }

  Future<bool> saveImageFile(Uint8List imageBytes, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          imagePath = directory!.path.toString();
          print(directory.path);
          // String newPath = "";
          // List<String> folders = directory!.path.split("/");
          // for (int x = 1; x < folders.length; x++) {
          //   String folder = folders[x];
          //   if (folder != "Android") {
          //     newPath += "/" + folder;
          //   } else {
          //     break;
          //   }
          // }
          // newPath = newPath + "/mail-processing2";
          // directory = Directory(newPath);
        } else {
          if (await _requestPermission(Permission.photos)) {
            directory = await getTemporaryDirectory();
            imagePath = directory.path;
            print(directory.path);
          } else {
            return false;
          }
        }
      }
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        // saveFile.writeAsString("Text");
        saveFile.writeAsBytesSync(imageBytes);

        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        File saveFile2 = File(directory.path + "/$fileName");
        // print(await saveFile2.readAsString());
        print("Directory" + directory.listSync().toString());
        return true;
      }
    } catch (e) {
      print("Something happened in saveImageFile method");
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    //var status = await permission.status;
    //print("Permission Status Code: " + status.toString() + " " + status.name);

    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  processImage(String imagePath) async {
    // var image = File('/storage/emulated/0/mail-processing/mailpiece.jpg');
    CloudVisionApi vision = CloudVisionApi();
    print("processImage: " + imagePath);
    var image = File(imagePath);
    var imageByte;
    // if (await _requestPermission(Permission.storage)) {
    // print("Permission Request went through (processImage)");
    imageByte = image.readAsBytesSync();
    // }

    var a = base64.encode(imageByte);
    print(a);
    // MailResponse s = await vision.search(a);
    var objMr = await vision.search(a);
    for (var address in objMr.addresses) {
      address.validated =
          await UspsAddressVerification().verifyAddressString(address.address);
    }
    _barcodeScannerApi = BarcodeScannerApi();
    // File img = await _barcodeScannerApi!.getImageFileFromAssets(filePath);
    File img = File(filePath);
    _barcodeScannerApi!.setImageFromFile(img);

    List<codeObject> codes = await _barcodeScannerApi!.processImage();
    for (final code in codes) {
      objMr.codes.add(code);
    }
    var output = objMr.toJson().toString();
    print(output);
    // print("Json: " + s.toJson().toString());
    // return s;
  }

  @override
  initState() {
    // TODO: implement initState
    context.loaderOverlay.show();
    deleteImageFiles();
    context.loaderOverlay.hide();
    sleep(const Duration(seconds: 1));
    for (int x = 0; x < widget.digest.attachments.length; x++) {
      print(widget.digest.attachments[x].attachmentNoFormatting);
      // Image s = Image.memory(base64Decode(
      //     widget.digest.attachments[attachmentIndex].attachmentNoFormatting));
      saveImageFile(
          base64Decode(widget.digest.attachments[x].attachmentNoFormatting),
          "mailpiece" + x.toString() + ".jpg");
      filePath = "${imagePath}/mailpiece$x.jpg";
      print(filePath);
      // processImage("${imagePath}/mailpiece$x.jpg");
      super.initState();
    }
    processImage("${imagePath}/mailpiece0.jpg");
  }

  static Route _buildRoute(BuildContext context, Object? params) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => MainWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MailWidget - FRAME
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/main');
                      Navigator.restorablePush(context, _buildRoute);
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
                          "USPS Informed Delivery Daily Digest",
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
            Row(
              children: [
                Expanded(
                  child: Center(
                      child: Container(
                          //child: Image.asset(widget.digest.attachments[attachmentIndex].attachment)), //This will eventually be populated with the downloaded image from the digest
                          child: widget.digest.attachments.isNotEmpty
                              ? Image.memory(base64Decode(widget
                                  .digest
                                  .attachments[attachmentIndex]
                                  .attachmentNoFormatting))
                              : Image.asset('assets/NoAttachments.png'))),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    //padding: EdgeInsets.only(left: 20),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () => showLinkDialog(),
                        child: const Text(
                          "Links",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shadowColor: Colors.grey,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    //: EdgeInsets.only(right: 10),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          "All Details",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shadowColor: Colors.grey,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seekBack();
                          });
                        },
                        child: Icon(Icons.skip_previous, size: 50)),
                    Text(widget.digest.attachments.isNotEmpty
                        ? (attachmentIndex + 1).toString() +
                            "/" +
                            widget.digest.attachments.length.toString()
                        : "0/0"),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seekForward(widget.digest.attachments.length);
                          });
                        },
                        child: Icon(Icons.skip_next, size: 50))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  void seekBack() {
    if (attachmentIndex != 0) {
      attachmentIndex = attachmentIndex - 1;
      filePath = '${imagePath}/mailpiece${attachmentIndex.toString()}.jpg';
      print("seekBack: " + filePath);
      processImage('${imagePath}/mailpiece${attachmentIndex.toString()}.jpg');
    }
  }

  void seekForward(int max) {
    if (attachmentIndex < max - 1) {
      attachmentIndex = attachmentIndex + 1;
      filePath = '${imagePath}/mailpiece${attachmentIndex.toString()}.jpg';
      print("seekForward: " + filePath);
      processImage('${imagePath}/mailpiece${attachmentIndex.toString()}.jpg');
    }
  }

  void showLinkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Link Dialog"),
          content: Container(
            height: 300.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.digest.links.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ElevatedButton(
                    child: Text(widget.digest.links.isNotEmpty
                        ? widget.digest.links[index].info == ""
                            ? widget.digest.links[index].link
                            : widget.digest.links[index].info
                        : ""),
                    onPressed: () => openLink(widget.digest.links.isNotEmpty
                        ? widget.digest.links[index].link
                        : ""),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void openLink(String link) async {
    if (link != "") {
      Uri uri = Uri.parse(link);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication))
        throw 'Could not launch $uri';
    }
  }
}
