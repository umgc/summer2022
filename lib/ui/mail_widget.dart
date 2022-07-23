import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../main.dart';
import '../read_info.dart';
import '../ui/main_menu.dart';
import '../image_processing/usps_address_verification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../image_processing/google_cloud_vision_api.dart';
import '../speech_to_text.dart';
import '../models/MailResponse.dart';
import '../image_processing/barcode_scanner.dart';
import '../models/Arguments.dart';
import '../models/Code.dart';
import '../models/Digest.dart';
import '../models/Logo.dart';
import './bottom_app_bar.dart';

class MailWidget extends StatefulWidget {
  final Digest digest;

  MailWidget({required this.digest});

  @override
  State<MailWidget> createState() {
    return MailWidgetState();
  }
}

class MailWidgetState extends State<MailWidget> {
  ReadDigestMail? reader;
  int attachmentIndex = 0;
  List<Link> links = <Link>[];
  FontWeight commonFontWt = FontWeight.w700;
  double commonFontSize = 32;
  double commonBorderWidth = 2;
  double commonButtonHeight = 60;
  double commonCornerRadius = 8;

  ButtonStyle commonButtonStyleElevated(Color? primary, Color? shadow)
  {
    return ElevatedButton.styleFrom(
      textStyle: TextStyle(fontWeight: FontWeight.w700,fontSize: commonFontSize),
      primary: primary,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(commonCornerRadius))),
      side: BorderSide( width: commonBorderWidth, color: Colors.black ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
      if(widget.digest.attachments.isNotEmpty) {
        reader = ReadDigestMail();
        reader!.setCurrentMail(widget.digest.attachments[attachmentIndex].detailedInformation);
        buildLinks();
        readMailPiece();
      }
      super.initState();
      stt.setCurrentPage("mail", this);
  }

  MailResponse getCurrentDigestDetails() {
    return widget.digest.attachments[attachmentIndex].detailedInformation;
  }

  static Route _buildRoute(BuildContext context, Object? params) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => const MainWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MailWidget - FRAME

    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Digest"),
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Text(
                          style: TextStyle(fontSize: 20),
                          "",
                        ),
                      ),
                    ),
                  ),
                const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              const Expanded(
                child: Center(
                  child: Text(
                    style: TextStyle(fontSize: 20),
                    "USPS Informed Delivery Daily Digest",
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_back,
                size: 50,
                color: Color.fromARGB(0, 255, 255, 1),
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
            Padding( // MODE Dialog Box
              padding: const EdgeInsets.only(top:0, left: 30, right: 30),
              child: Row( // LATEST and UNREAD Buttons
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: commonButtonHeight, // LATEST Button
                      child: OutlinedButton(
                        onPressed: () { showLinkDialog(); },
                        style: commonButtonStyleElevated(Colors.white, Colors.grey),
                        child: const Text("Links",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: commonButtonHeight, // UNREAD Button
                      child: OutlinedButton(
                        onPressed: () { readMailPiece(); },
                        style: commonButtonStyleElevated(Colors.white, Colors.grey),
                        child: const Text("All Details", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.grey,
                      heroTag: "f1",
                      onPressed: () {
                        setState(() { seekBack(); });
                      },
                      child: const Icon(Icons.skip_previous),
                    ),
                    Text(widget.digest.attachments.isNotEmpty
                        ? "${attachmentIndex + 1}/${widget.digest.attachments.length}" : "0/0"),
                    FloatingActionButton(
                      backgroundColor: Colors.grey,
                      heroTag: "f2",
                      onPressed: () {
                        setState(() { seekForward(1); });
                      },
                      child: const Icon(Icons.skip_next),
                    ),
                  ]),
            )
          ],
        ),
      ),
    ])));
  }

  void seekBack() {
    if (attachmentIndex != 0) {
      attachmentIndex = attachmentIndex - 1;
      reader!.setCurrentMail(widget.digest.attachments[attachmentIndex].detailedInformation);
      buildLinks();
      readMailPiece();
    }
  }

  void seekForward(int length) {
    if (attachmentIndex < widget.digest.attachments.length - 1) {
      attachmentIndex = attachmentIndex + 1;
      reader!.setCurrentMail(widget.digest.attachments[attachmentIndex].detailedInformation);
      buildLinks();
      readMailPiece();
    }
  }

  void showLinkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Link Dialog"),
          content: SizedBox(
            height: 300.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: links.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ElevatedButton(
                    child: Text(links.isNotEmpty
                        ? links[index].info == ""
                            ? links[index].link
                            : links[index].info
                        : ""),
                    onPressed: () => openLink(links.isNotEmpty
                        ? links[index].link
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
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    }
  }

  void buildLinks() {
    List<Link> newLinks = <Link>[];
    widget.digest.links.forEach((link) {
      newLinks.add(link);
    });
    if(widget.digest.attachments.isNotEmpty) {
      widget.digest.attachments[attachmentIndex].detailedInformation.codes.forEach((code) {
        Link newLink = Link();
        newLink.info = "";
        newLink.link = code.info;
        newLinks.add(newLink);
      });
    }

    links = newLinks;
  }

  void readMailPiece() {
    try{
      if(reader != null) {
        reader!.readDigestInfo();
      }
    } catch (e) {
      print(e.toString());
    }

  }

}
