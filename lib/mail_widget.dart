import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Arguments.dart';
import 'models/Digest.dart';

class MailWidget extends StatefulWidget {
  final Digest digest;

  const MailWidget({
    required this.digest
  });

  @override
  State<MailWidget> createState() {
    return _MailWidgetState();
  }
}

class _MailWidgetState extends State<MailWidget> {
  int attachmentIndex = 0;

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
                        child: Image.memory(base64Decode(widget.digest.attachments[attachmentIndex].attachmentNoFormatting)))
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    //padding: EdgeInsets.only(left: 20),
                    child: Expanded(
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
                  Center(
                    //: EdgeInsets.only(right: 10),
                    child: Expanded(
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
                    ElevatedButton(onPressed: () { setState(() { seekBack(); }); }, child: Icon(Icons.skip_previous, size: 50)),
                    Text((attachmentIndex + 1).toString() + "/" + widget.digest.attachments.length.toString()),
                    ElevatedButton(onPressed: () { setState(() { seekForward(widget.digest.attachments.length); });  }, child: Icon(Icons.skip_next, size: 50))

                  ]),
            )
          ],
        ),
      ),
    );
  }

  void seekBack() {
    if(attachmentIndex != 0) {
      attachmentIndex = attachmentIndex - 1;
    }
    print(attachmentIndex);
  }

  void seekForward(int max) {
    if(attachmentIndex < max - 1) {
      attachmentIndex = attachmentIndex + 1;
    }
    print(attachmentIndex);
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
                    child: Text(widget.digest.links[index].info == "" ? widget.digest.links[index].link : widget.digest.links[index].info),
                    onPressed: () => openLink(widget.digest.links[index].link),
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
    Uri uri = Uri.parse(link);
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }

}
