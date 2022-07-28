import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:intl/intl.dart';

class EmailContent extends StatefulWidget {

  final int index;
  final List<MimeMessage> emails;

  const EmailContent(this.emails, {Key? key, this.index = 0}) : super(key: key);

  @override
  State<EmailContent> createState() => _EmailContentState();
}

class _EmailContentState extends State<EmailContent> {
  List<Uint8List> imageList = [];
  Uint8List? _image;
  File? imgFile;
  @override
  initState() {
    super.initState();
    print("Attachment?  ${widget.emails[widget.index]
            .hasAttachmentsOrInlineNonTextualParts()}");

    var s = widget.emails[widget.index].parts;
    if (s != null) {
      for (MimePart d in s) {
        if (d.mediaType.isImage) {
          _image = d.decodeContentBinary();
          if (_image != null) {
            imageList.add(_image!);
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Other Mail",
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
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
                Row(
                  children: [
                    const Text(
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
                Row(
                  children: [
                    const Text(
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
                Row(
                  children: [
                    Column(
                      children: const [
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
                const Text(
                  "Body: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.emails[widget.index]
                    .decodeTextPlainPart()
                    .toString()),
                imageList.isNotEmpty
                    ? SizedBox(
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
                    : const Text("No Images available")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
