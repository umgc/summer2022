import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInWidget extends StatefulWidget {
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
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
                          "Sign In",
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
              padding: EdgeInsets.only(top: 50),
            ),
            Container(
              padding: EdgeInsets.only(top: 150),
              color: Color.fromRGBO(228, 228, 228, 0.6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'E-Mail Address',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Row(
                    children: [
                      Container(
                        child: Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: TextField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 150),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                shadowColor: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
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
