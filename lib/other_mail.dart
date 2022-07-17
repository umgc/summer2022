import 'package:flutter/material.dart';
import './main_menu.dart';

class OtherMailWidget extends StatefulWidget {
  const OtherMailWidget({Key? key}) : super(key: key);

  @override
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
            Center(
              child: Row(
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
                        "Other Mail",
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
            ),
            Container(
              color: const Color.fromRGBO(228, 228, 228, 0.6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: const Text(
                          "Sender:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        "Neil Armstrong",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: const Text(
                          "Date:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        "Three Days Ago",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: const Text(
                          "Email Text:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 375,
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
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
