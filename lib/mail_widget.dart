import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MailWidget extends StatefulWidget {
  const MailWidget({Key? key}) : super(key: key);

  @override
  _MailWidgetState createState() => _MailWidgetState();
}

class _MailWidgetState extends State<MailWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MailWidget - FRAME

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Mail",
                      style: TextStyle(fontSize: 20),
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
                    child: Image.asset(
                        'assets/Image1.png'), //This will eventually be populated with the downloaded image from the digest
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  //padding: EdgeInsets.only(left: 20),
                  child: Expanded(
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
                Center(
                  //: EdgeInsets.only(right: 10),
                  child: Expanded(
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
                  children: const [
                    Icon(Icons.skip_previous, size: 50),
                    Text("1/6"),
                    Icon(Icons.skip_next, size: 50)
                  ]),
            )
          ],
        ),
      ),
    );
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
              itemCount: getLinks().length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ElevatedButton(
                    child: Text(getLinks()[index]),
                    onPressed: () => openLink(getLinks()[index]),
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

  List<String> getLinks() {
    List<String> links = [];
    links.add("https://google.com");
    links.add("https://facebook.com");
    links.add("https://umgc.edu");

    return links;
  }
}
