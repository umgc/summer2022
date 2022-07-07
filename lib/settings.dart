// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:global_configuration/global_configuration.dart';


class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingsWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      "Settings",
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
            // Container(
            //   padding: EdgeInsets.only(top: 100),
            // ),
            Container(
              color: const Color.fromRGBO(228, 228, 228, 0.6),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Envelope Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Sender: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("sender"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("sender", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Recipient: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("recipient"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("recipient", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Logos: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("logos"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("logos", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Links: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("links"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("links", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Sender Address: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("address"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("address", value);
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
                          padding: const EdgeInsets.only(top: 20),
                          child: const Text(
                            "Email Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Subject: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("email_subject"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("email_subject", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Email Text: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("email_text"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("email_text", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Sender Address: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("email_sender"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("email_sender", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Recipients: "),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: Switch(
                            value: GlobalConfiguration().getValue("email_recipients"),
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                GlobalConfiguration().updateValue("email_recipients", value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text("Autoplay"),
                        ),
                        ToggleSwitch(
                          customWidths: const [40.0, 40.0],
                          cornerRadius: 20.0,
                          activeBgColors: const [
                            [Colors.lightGreen],
                            [Colors.grey]
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: const ['|', 'O'],
                          onToggle: (index) {
                            print('switched to: $index');
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Text("Next Command"),
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
