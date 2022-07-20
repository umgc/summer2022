import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './main_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/Arguments.dart';
import 'models/Digest.dart';
import './main.dart';
import 'package:summer2022/speech_to_text.dart';


class OtherMailWidget extends StatefulWidget {
  final List<Digest> emails;

  const OtherMailWidget({
    required this.emails
  });

  @override
  State<OtherMailWidget> createState() {
    return OtherMailWidgetState();
  }
}

class OtherMailWidgetState extends State<OtherMailWidget> {
  late int index;

  @override
  void initState() {
    // index must be initialed before build or emails won't iterate
    super.initState();
    index = widget.emails.length-1;
    stt.setCurrentPage("email");
  }

  String removeLinks(Digest d){
    String bodyText = '';
    List<Link> list = [];
    RegExp carotsExpn = RegExp(r"\<https.+?\>");
    RegExp squaresExpn = RegExp(r"\[.+?\]");
    RegExp squaresExpn2 = RegExp(r"\[(.|\n|\r)*\]");
    RegExp tagsExpn = RegExp(r"r/");
    String text = d.message.decodeTextPlainPart() ?? ""; //get body text of email

    text = text.replaceAll('\r', '');
    text = text.replaceAll('\r\n', '\n');
    text = text.replaceAll('\n\n', '');
    text = text.replaceAll(carotsExpn,'');
    text = text.replaceAll(squaresExpn,'');
    text = text.replaceAll(squaresExpn2,'');
    text = text.replaceAll(tagsExpn,'');

    return text;
  }

  String convertToAgo(DateTime input){
    Duration diff = DateTime.now().difference(input);

    if(diff.inDays >= 1){
      return '${diff.inDays} day(s) ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hour(s) ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    //index = widget.emails.length-1;
    int emailsLen = widget.emails.length;
    //index = widget.emails.length-1;
    var parsedDate = DateTime.parse(widget.emails[index].message.decodeDate().toString());
    final DateFormat formatter = DateFormat('yyyy-MM-dd h:mm:ss');
    final String formatted = formatter.format(parsedDate);
    String timeAgo = convertToAgo(parsedDate);
    return Scaffold(
      //appBar: AppBar(title: Text(widget.emails[index].message.decodeDate().toString()),),
      appBar: AppBar(title: Text(formatted),),
      //appBar: AppBar(title: Text/*(widget.emails[index].decodeDate().toString()),*/''),
      body: Column(
        children: [
          SizedBox( height: 10, width: double.infinity,),
          new Expanded(
            flex: 1,
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,//.horizontal
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'SUBJECT: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, height: 2)),
                      TextSpan(text: widget.emails[index].message.decodeSubject().toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16)),
                      TextSpan(text: '\nSENDER: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, height: 2)),
                      TextSpan(text: widget.emails[index].message.decodeSender().toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16)),
                      TextSpan(text: '\nSENT: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, height: 2)),
                      TextSpan(text: timeAgo + '\n\n', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16)),
                      TextSpan(text: removeLinks(widget.emails[index]), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16)),
                    ]
                ),
              ),
            ),
          ),
          //Image.network(emails[index].decodeSubject().toString()),
          SizedBox( height: 15, width: double.infinity,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                heroTag: "f1",
                onPressed: (){
                  setState(() {
                    if(index != widget.emails.length-1){
                      index ++;
                    }
                  });
                },
                child:Icon(Icons.arrow_back_ios) ,
              ),
              Text((emailsLen - (index)).toString() + '/' + emailsLen.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              FloatingActionButton(
                heroTag: "f2",
                onPressed: (){

                  setState(() {
                    if(index!=0){
                      index --;
                    }
                  });

                },
                child:Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          SizedBox( height: 15, width: double.infinity,),
        ],
      ),
    );
  }
}


