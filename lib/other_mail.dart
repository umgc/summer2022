import 'package:flutter/material.dart';
import 'package:summer2022/main_menu.dart';

class OtherMailWidget extends StatefulWidget {
  OtherMailWidgetState createState() => OtherMailWidgetState();
}

class OtherMailWidgetState extends State<OtherMailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Center(
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
                            "Other Mail",
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
            ),
            Container(
              color: Color.fromRGBO(228, 228, 228, 0.6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            "Sender:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          child: Text(
                            "Neil Armstrong",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: [
                      Container(
                        child: Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            "Date:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          child: Text(
                            "Three Days Ago",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: [
                      Container(
                        child: Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            "Email Text:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: [
                      Container(
                        child: SizedBox(
                          width: 375,
                          child: Text(
                            maxLines: 5,
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.skip_previous, size: 50),
                    Text("1/47"),
                    Icon(Icons.skip_next, size: 50)
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
