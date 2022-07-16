import 'package:flutter/material.dart';
import './Client.dart';
import './keychain.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './backend_testing.dart';

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
                      onPressed: () {
                        if (mail_type == "Email") {
                          Navigator.pushNamed(context, '/other_mail');
                        } else {
                          Navigator.pushNamed(context, '/digest_mail');
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
                          Navigator.pushNamed(context, '/digest_mail');
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
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/backend_testing');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const BackendPage(
                  //               title: "USPS Backend Testing",
                  //             )));
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
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () async {
                    //Add logic to remove the credentials from the secure storage
                    Keychain().deleteAll();
                    //TODO: Make sure Client logs out not sure if I need to?
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
}
