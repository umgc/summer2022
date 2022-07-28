import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:summer2022/read_info.dart';
import 'bottom_app_bar.dart';
import 'package:summer2022/models/Digest.dart';
import 'package:summer2022/main.dart';

class OtherMailWidget extends StatefulWidget {
  final List<Digest> emails;

  const OtherMailWidget({required this.emails});

  @override
  State<OtherMailWidget> createState() {
    return OtherMailWidgetState();
  }
}

class OtherMailWidgetState extends State<OtherMailWidget> {
  ReadMail? reader;
  late int index;
  FontWeight commonFontWt = FontWeight.w500;
  double commonFontSize = 28;

  @override
  void initState() {
    // index must be initialed before build or emails won't iterate
    super.initState();
    index = widget.emails.length - 1;
    stt.setCurrentPage("email", this);
    if(widget.emails.isNotEmpty) {
        reader = ReadMail();
        reader!.setCurrentMail(widget.emails[index].message);
           
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => otherMailAuto(context));
  }

  otherMailAuto(context) async {
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

  MimeMessage getCurrentEmailMessage() {
    return widget.emails[index].message;
  }

  String removeLinks(Digest d) {
    RegExp linkExp = RegExp(
        r"(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])");
    RegExp carotsExpn = RegExp(r"\<https.+?\>");
    RegExp squaresExpn = RegExp(r"\[.+?\]");
    RegExp squaresExpn2 = RegExp(r"\[(.|\n|\r)*\]");
    RegExp tagsExpn = RegExp(r"r/");
    String text =
        d.message.decodeTextPlainPart() ?? ""; //get body text of email

    text = text.replaceAll(linkExp, '');
    text = text.replaceAll('\r', '');
    text = text.replaceAll('\r\n', '\n');
    text = text.replaceAll('\n\n', '');
    text = text.replaceAll(carotsExpn, '');
    text = text.replaceAll(squaresExpn, '');
    text = text.replaceAll(squaresExpn2, '');
    text = text.replaceAll(tagsExpn, '');

    return text;
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    int emailsLen = widget.emails.length;
    var parsedDate =
        DateTime.parse(widget.emails[index].message.decodeDate().toString());
    final DateFormat formatter = DateFormat('yyyy-MM-dd h:mm:ss');
    final String formatted = formatter.format(parsedDate);
    String timeAgo = convertToAgo(parsedDate);
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          formatted,
          style: TextStyle(fontWeight: commonFontWt, fontSize: commonFontSize),
        ),
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                        text: 'SUBJECT: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 2)),
                    TextSpan(
                        text: widget.emails[index].message
                            .decodeSubject()
                            .toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)),
                    const TextSpan(
                        text: '\nSENDER: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 2)),
                    TextSpan(
                        text: widget.emails[index].message
                            .decodeSender()
                            .toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)),
                    const TextSpan(
                        text: '\nSENT: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 2)),
                    TextSpan(
                        text: '$timeAgo\n\n',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)),
                    TextSpan(
                        text: removeLinks(widget.emails[index]),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)),
                  ]),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.grey,
                  heroTag: "f1",
                  onPressed: () {
                    seekBack();
                  },
                  child: const Icon(Icons.skip_previous),
                ),
                Text(
                  '${emailsLen - (index)}/$emailsLen',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.grey,
                  heroTag: "f2",
                  onPressed: () {
                    seekForward();
                    //autoplay();
                  },
                  child: const Icon(Icons.skip_next),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  void seekBack() {
    setState(() {
      if (index != widget.emails.length - 1) {
        index++;
      }
      stop();
      reader!.setCurrentMail(widget.emails[index].message);
      
    });
    try {
      setTtsState(TtsState.playing);
      readMailPiece();
    } catch(e) {
      print("ERROR: Seek back: ${e.toString()}");
    }
  }

  void seekForward() {
    if (mounted) {
      setState(() {
        if (index != 0) {
          index--;
        }
        stop();
        reader!.setCurrentMail(widget.emails[index].message);
      });
      try {
        setTtsState(TtsState.playing);
        readMailPiece();
      } catch(e) {
        print("ERROR: Seek forward: ${e.toString()}");
      }
      autoplay();
    }
  }

  Future<bool> readMailPiece() async {
    try{
      if(reader != null) {
        await reader!.readEmailInfo();
      }
    } catch (e) {
      print("ERROR: Read mail piece: ${e.toString()}");
    }
    return true;
  }
}
