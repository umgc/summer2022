import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/main.dart';
import 'package:summer2022/speech_commands/read_info.dart';
import 'package:summer2022/ui/main_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/models/Digest.dart';
import 'package:summer2022/ui/bottom_app_bar.dart';

class MailWidget extends StatefulWidget {
  final Digest digest;

  const MailWidget({Key? key, required this.digest}) : super(key: key);

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

  ButtonStyle commonButtonStyleElevated(Color? primary, Color? shadow) {
    return ElevatedButton.styleFrom(
      textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: commonFontSize),
      primary: primary,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(commonCornerRadius))),
      side: BorderSide(width: commonBorderWidth, color: Colors.black),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    if (widget.digest.attachments.isNotEmpty) {
      reader = ReadDigestMail();
      reader!.setCurrentMail(
          widget.digest.attachments[attachmentIndex].detailedInformation);
      buildLinks(); 
    }
    stt.setCurrentPage("mail", this);
    WidgetsBinding.instance.addPostFrameCallback((_) => digestAuto(context));
  }

  digestAuto(context) async {
    try {
        setTtsState(TtsState.playing);
        readMailPiece();
        //await Future.delayed(const Duration(seconds: 5));
    } catch(e) {
        print("ERROR: Read mail piece in init: ${e.toString()}");
    }
    autoplay();
  }

  Future<void> autoplay() async {
    // Wait a few seconds before starting to check if speaking is done
    await Future.delayed(const Duration(seconds: 3));
    setTtsState(TtsState.playing);
    if (GlobalConfiguration().getValue("autoplay")) {
      if (mounted) {
        while (ttsState == TtsState.playing){
          print("waiting");
          await Future.delayed(const Duration(seconds: 1));
        }
        print("done waiting");
        await Future.delayed(const Duration(seconds: 5));
        seekForward();
      }
    }
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
      bottomNavigationBar: const BottomBar('digest'),
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
              children: const [
                Expanded(
                  child: Center(
                    child: Text(
                      style: TextStyle(fontSize: 20),
                      "",
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
            Padding(
              // MODE Dialog Box
              padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
              child: Row(
                  // LATEST and UNREAD Buttons
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: commonButtonHeight, // LATEST Button
                      child: OutlinedButton(
                        onPressed: () {
                          showLinkDialog();
                        },
                        style: commonButtonStyleElevated(
                            Colors.white, Colors.grey),
                        child: const Text("Links",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: commonButtonHeight, // UNREAD Button
                      child: OutlinedButton(
                        onPressed: () {
                          readMailPiece();
                        },
                        style: commonButtonStyleElevated(
                            Colors.white, Colors.grey),
                        child: const Text("All Details",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ]),
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
                        setState(() {
                          seekBack();
                        });
                      },
                      child: const Icon(Icons.skip_previous),
                    ),
                    Text(widget.digest.attachments.isNotEmpty
                        ? "${attachmentIndex + 1}/${widget.digest.attachments.length}"
                        : "0/0"),
                    FloatingActionButton(
                      backgroundColor: Colors.grey,
                      heroTag: "f2",
                      onPressed: () {
                        setState(() {
                          seekForward();
                        });
                      },
                      child: const Icon(Icons.skip_next),
                    ),
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
          .toJson());
      stop();
      reader!.setCurrentMail(
          widget.digest.attachments[attachmentIndex].detailedInformation);
      buildLinks();
      readMailPiece();
    }
  }

  void seekForward([int length = 0]) {
    if (attachmentIndex <
        (length != 0 ? length : widget.digest.attachments.length - 1)) {
      attachmentIndex = attachmentIndex + 1;
      print(widget.digest.attachments[attachmentIndex].detailedInformation
          .toJson());
      stop();
      reader!.setCurrentMail(
          widget.digest.attachments[attachmentIndex].detailedInformation);
      buildLinks();
    }
    try {
      setTtsState(TtsState.playing);
      readMailPiece();
    } catch(e) {
      print("ERROR: Seek forward: ${e.toString()}");
    }
    autoplay();
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
                    onPressed: () =>
                        openLink(links.isNotEmpty ? links[index].link : ""),
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
    for (var link in widget.digest.links) {
      newLinks.add(link);
    }
    if (widget.digest.attachments.isNotEmpty) {
      for (var code in widget.digest.attachments[attachmentIndex].detailedInformation.codes) {
        Link newLink = Link();
        newLink.info = "";
        newLink.link = code.info;
        newLinks.add(newLink);
      }
    }
    links = newLinks;
    reader!.links = links;
  }

  Future<void> readMailPiece() async {
    try {
      if (reader != null) {
        Future.wait([reader!.readDigestInfo()]);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
