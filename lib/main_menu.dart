import 'package:flutter/material.dart';
import 'package:summer2022/digest_email_parser.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './backend_testing.dart';
import 'models/Arguments.dart';
import 'models/Digest.dart';

class MainWidget extends StatefulWidget {
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  DateTime selected_date = DateTime.now();
  String mail_type = "Email";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: OutlinedButton.icon(
                      onPressed: () => selectDate(context),
                      icon: Icon(Icons.calendar_month_outlined),
                      label: Text("$mail_type Date Selection"),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Text("Mail Type:"),
                  DropdownButton(
                      value: mail_type,
                      items: [
                        DropdownMenuItem<String>(
                          value: "Email",
                          child: Text("Email"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Digest",
                          child: Text("Digest"),
                        ),
                      ],
                      onChanged: (String? valueSelected) {
                        setState(() {
                          mail_type = valueSelected!;
                        });
                      }),
                ],
              ),
            ),
            Container(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_outlined),
                    label: const Text("Scan Mail"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: OutlinedButton(
                      onPressed: () async {
                        if (mail_type == "Email") {
                          Navigator.pushNamed(context, '/other_mail');
                        } else {
                          await getDigest();
                          Navigator.pushNamed(context, '/digest_mail', arguments: MailWidgetArguments(digest));
                        }
                      },
                      child: const Text("Latest",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    child: OutlinedButton(
                      onPressed: () {
                        if (mail_type == "Email") {
                          Navigator.pushNamed(context, '/other_mail');
                        } else {
                          getDigest();
                          while(digest != null)
                          Navigator.pushNamed(context, '/digest_mail', arguments: MailWidgetArguments(digest));
                        }
                      },
                      child: const Text("Unread",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text("Settings",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/backend_testing');
                      },
                      child: const Text("Backend Testing",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/enough_mail_sample');
                      },
                      child: const Text("Enough Mail Tester",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_in');
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selected_date)) {
      if (mail_type == "Email") {
        Navigator.pushNamed(context, '/other_mail');
      } else {
        Navigator.pushNamed(context, '/digest_mail');
      }

      setState(() {
        selected_date = picked;
      });
    }
  }

  Future<void> selectOtherMailDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: DateTime(1970),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selected_date)) {
      Navigator.pushNamed(context, '/other_mail');
      setState(() {
        selected_date = picked;
      });
    }
  }

  late Digest digest;

  Future<void> getDigest() async {
    await DigestEmailParser().createDigest("GartrellBarry@gmail.com", "jcgbbrahopwwffma", selected_date).then((value) => digest = value);
  }
}
