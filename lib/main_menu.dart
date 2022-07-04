import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainWidget extends StatefulWidget {
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  DateTime selected_date = DateTime.now();
  bool email_selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () => selectDate(context),
                    icon: Icon(Icons.calendar_month_outlined),
                    label: determineButtonText(),
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
                        if (!email_selected) {
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
                        if (!email_selected) {
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Switch(
                      value: email_selected,
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        setState(() {
                          email_selected = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    "Digest",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
      if (!email_selected) {
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

  Widget determineButtonText() {
    if (email_selected == true) {
      return Text("Digest Selection");
    } else {
      return Text("Email Selection");
    }
  }
}
