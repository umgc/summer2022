import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class EmailContent extends StatefulWidget {
  //final CallbackHandle? selectorHandler;

  //late MimeMessage mineMessage;
  final int index;
  final List<MimeMessage> emails;

  //EmailContent(this.mineMessage, this.selectorHandler);
  // EmailContent();
  EmailContent(@required this.emails, {@required this.index = 0});

  @override
  State<EmailContent> createState() => _EmailContentState();
}

class _EmailContentState extends State<EmailContent> {
  List<Uint8List> imageList = [];
  Uint8List? _image;
  File? imgFile;
  initState() {
    print("Attachment?  " +
        widget.emails[widget.index]
            .hasAttachmentsOrInlineNonTextualParts()
            .toString());
    // var content = widget.emails[widget.index]
    //     .findContentInfo(disposition: ContentDisposition.attachment);
    // print("Content: " + content.length.toString());
    // print(widget.emails[widget.index].toString());
    // for (var attachment in widget.emails[widget.index].allPartsFlat)
    var s = widget.emails[widget.index].parts;
    if (s != null) {
      for (MimePart d in s) {
        if (d.mediaType.isImage) {
          _image = d.decodeContentBinary();
          if (_image != null) {
            imageList.add(_image!);
            // var imgFile = storeImageToTempDirectory();
            // print('The File Directory: ${imgFile.toString()}');
          }
        }
      }
    }
    setState(() {});
  }

  // storeImageToTempDirectory() async {
  //   final directory = await getTemporaryDirectory();
  //   const fileName = "mailpiece.jpg";
  //   imgFile = File("${directory.path}/${fileName}");
  //   imgFile!.writeAsBytes(_image!);
  //   print("${directory.path}/${fileName}");
  //   return imgFile;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Other Mail",
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "To: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.emails[widget.index].to.toString(),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "From: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.emails[widget.index].from![0].personalName
                              .toString()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "Date: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(DateFormat("EEEE dd-MM-yyyy hh:mm")
                              .format(widget.emails[widget.index].decodeDate()!)
                              .toString()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Subject: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Text(
                          widget.emails[widget.index]
                              .decodeSubject()
                              .toString(),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Body: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(widget.emails[widget.index]
                      .decodeTextPlainPart()
                      .toString()),
                  imageList.isNotEmpty
                      ? Container(
                          height: 320,
                          width: 320,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.memory(
                              imageList[0],
                              width: 320,
                              height: 320,
                            ),
                          ),
                        )
                      : Container(
                          child: Text("No Images available"),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
