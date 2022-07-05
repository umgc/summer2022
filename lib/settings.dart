import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsWidget extends StatefulWidget {
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingsWidget> {
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
                      Navigator.pushNamed(context, '/');
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
            Container(
              padding: EdgeInsets.only(top: 200),
            ),
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
                  buildSettingOptions(),
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

Widget buildSettingOptions() {
  var stringList = [
    "Sender:",
    "Recipient: ",
    "Logos:",
    "Links:",
    "Sender Address:"
  ];

  // Create a List<Text> (or List<MyWidget>) using each String from stringList

  List<Widget> row_list = [];

  for (var label in stringList) {
    row_list.add(
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("$label"),
            ),
            Container(
              padding: EdgeInsets.only(right: 50),
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
          ],
        ),
      ),
    );
  }

  // use that list however you want!
  return Column(children: row_list);
}

        /*child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 50),
                  Align(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Settings",
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text("Sender:"),
                          Spacer(),
                          ToggleSwitch(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text("Recipient:"),
                          Spacer(),
                          ToggleSwitch(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(children: [
                        Text("Logos:"),
                        Spacer(),
                        ToggleSwitch(
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
                      ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(children: [
                        Text("Links:"),
                        Spacer(),
                        ToggleSwitch(
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
                      ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(children: [
                        Text("Sender Address:"),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
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
                      ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Row(children: [
                        Text("Autoplay Next:"),
                        Spacer(),
                        ToggleSwitch(
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
                      ]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),*/


// class SettingsWidget extends StatefulWidget {
//   @override
//   _SettingsWidgetState createState() => _SettingsWidgetState();
// }

// class _SettingsWidgetState extends State<SettingsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // Figma Flutter Generator SettingsWidget - FRAME

//     return Container(
//         width: 375,
//         height: 760,
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(255, 255, 255, 1),
//         ),
//         child: Stack(textDirection: TextDirection.ltr, children: <Widget>[
//           Positioned(
//               top: 106,
//               left: 0,
//               child: Container(
//                   width: 375,
//                   height: 511,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                     color: Color.fromRGBO(228, 228, 228, 0.6000000238418579),
//                   ))),
//           Positioned(
//               top: 399,
//               left: 30,
//               child: Text(
//                 'Next or Autoplay (per Mail item)',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 22,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 21,
//               left: 117,
//               child: Text(
//                 'Settings',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 36,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 119,
//               left: 29,
//               child: Text(
//                 'Envelope Details',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 22,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 162,
//               left: 29,
//               child: Text(
//                 'Sender:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 201,
//               left: 29,
//               child: Text(
//                 'Recipient:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 242,
//               left: 29,
//               child: Text(
//                 'Logos:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 281,
//               left: 29,
//               child: Text(
//                 'Links:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 319,
//               left: 29,
//               child: Text(
//                 'Sender Address:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 456,
//               left: 29,
//               child: Text(
//                 'Autoplay:',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Roboto',
//                     fontSize: 24,
//                     letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.normal,
//                     height: 1.5 /*PERCENT not supported*/
//                     ),
//               )),
//           Positioned(
//               top: 650,
//               left: 21,
//               child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
//                           offset: Offset(0, 4),
//                           blurRadius: 4)
//                     ],
//                     color: Color.fromRGBO(242, 242, 242, 1),
//                     borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
//                   ))),
//           Positioned(
//               top: 650,
//               left: 143,
//               child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
//                           offset: Offset(0, 4),
//                           blurRadius: 4)
//                     ],
//                     color: Color.fromRGBO(242, 242, 242, 1),
//                     borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
//                   ))),
//           Positioned(
//               top: 650,
//               left: 264,
//               child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
//                           offset: Offset(0, 4),
//                           blurRadius: 4)
//                     ],
//                     color: Color.fromRGBO(242, 242, 242, 1),
//                     borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
//                   ))),
//         ]));*/
//   }
// }
