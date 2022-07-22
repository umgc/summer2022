import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:summer2022/ui/main_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/MailResponse.dart';
import '../models/Digest.dart';
import 'bottom_app_bar.dart';

class MailWidget extends StatefulWidget {
  final Digest digest;

  const MailWidget({required this.digest});

  @override
  State<MailWidget> createState() {
    return MailWidgetState();
  }
}

class MailWidgetState extends State<MailWidget> {
  int attachmentIndex = 0;

  @override
  initState() {
    print(widget.digest.attachments[attachmentIndex].detailedInformation
        .toJson()); //TODO Read Mail through tts
    super.initState();
    stt.setCurrentPage("mail");
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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                    //Navigator.restorablePush(context, _buildRoute);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
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
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  //padding: EdgeInsets.only(left: 20),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () => showLinkDialog(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                      ),
                      child: const Text(
                        "Links",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  //: EdgeInsets.only(right: 10),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                      ),
                      child: const Text(
                        "All Details",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seekBack();
                          });
                        },
                        child: const Icon(Icons.skip_previous, size: 50)),
                    Text(widget.digest.attachments.isNotEmpty
                        ? "${attachmentIndex + 1}/${widget.digest.attachments.length}"
                        : "0/0"),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seekForward(widget.digest.attachments.length);
                          });
                        },
                        child: const Icon(Icons.skip_next, size: 50))
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
      print(widget.digest.attachments[attachmentIndex].detailedInformation
          .toJson()); //TODO Read Mail through tts
    }
  }

  void seekForward(int max) {
    if (attachmentIndex < max - 1) {
      attachmentIndex = attachmentIndex + 1;
      print(widget.digest.attachments[attachmentIndex].detailedInformation
          .toJson()); //TODO Read Mail through tts
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
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    }
  }
}