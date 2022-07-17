// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './backend_testing.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  DateTime selectedDate = DateTime.now();
  String mailType = "Email";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () => selectDate(context),
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text("$mailType Date Selection"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
                const Text("Mail Type:"),
                DropdownButton(
                    value: mailType,
                    items: const [
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
                        mailType = valueSelected!;
                      });
                    }),
              ],
            ),
            Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/backend_testing');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const BackendPage(
                //               title: "USPS Backend Testing",
                //             )));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shadowColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              child: const Text("Backend Testing",
                  style: TextStyle(color: Colors.black)),
            ),
            Container(
              child: Column(
              children: [
              Center(
                child: Column(
                  children: [
                  OutlinedButton(
                  onPressed: () {
                    if (mailType == "Email") {
                      Navigator.pushNamed(context, '/other_mail');
                    } else {
                      Navigator.pushNamed(context, '/digest_mail');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: const Text("Latest",
                      style: TextStyle(color: Colors.black)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (mailType == "Email") {
                        Navigator.pushNamed(context, '/other_mail');
                      } else {
                        Navigator.pushNamed(context, '/digest_mail');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: const Text("Unread",
                      style: TextStyle(color: Colors.black)),
                  ),
                ]
              ),
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                 ),
                  child: const Text("Settings",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_in');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ] // Children
          ),
      ),
    ])));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selectedDate)) {
      if (mailType == "Email") {
        Navigator.pushNamed(context, '/other_mail');
      } else {
        Navigator.pushNamed(context, '/digest_mail');
      }

      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectOtherMailDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selectedDate)) {
      Navigator.pushNamed(context, '/other_mail');
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
