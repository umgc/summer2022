import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsWidget extends StatefulWidget {
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingsWidget> {
  bool digest_sender = true;
  bool digest_recipient = true;
  bool digest_logos = true;
  bool digest_links = true;
  bool digest_sender_address = true;

  bool email_subject = true;
  bool email_text = true;
  bool email_sender_address = true;
  bool email_recipients = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/main');
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Text(
                          style: TextStyle(fontSize: 20),
                          "Settings",
                        ),
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
            ),
            // Container(
            //   padding: EdgeInsets.only(top: 100),
            // ),
            Container(
              color: Color.fromRGBO(228, 228, 228, 0.6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            "Envelope Details",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Sender: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: digest_sender,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                digest_sender = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Recipient: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: digest_recipient,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                digest_recipient = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Logos: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: digest_logos,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                digest_logos = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Links: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: digest_links,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                digest_links = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Sender Address: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: digest_sender_address,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                digest_sender_address = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            "Email Details",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Subject: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: email_subject,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                email_subject = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Email Text: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: email_text,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                email_text = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Sender Address: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: email_sender_address,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                email_sender_address = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Recipients: "),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: Switch(
                            value: email_recipients,
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                email_recipients = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Autoplay"),
                        ),
                        Container(
                          child: ToggleSwitch(
                            customWidths: [40.0, 40.0],
                            cornerRadius: 20.0,
                            activeBgColors: [
                              [Colors.lightGreen],
                              [Colors.grey]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            labels: ['|', 'O'],
                            onToggle: (index) {
                              print('switched to: $index');
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Next Command"),
                        ),
                      ],
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
}
