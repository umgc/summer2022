import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summer2022/Keychain.dart';
import 'package:summer2022/Client.dart';

class SignInWidget extends StatefulWidget {
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
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
                              controller: email_controller,
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
                              controller: password_controller,
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
                              onPressed: () async {
                                String email = email_controller.text.toString();
                                String password =
                                    password_controller.text.toString();
                                //If email validated through enough mail then switch to the main screen, if not, add error text to the to show on the screen
                                var loggedIn = await Client()
                                    .getImapClient(email, password);
                                //Store the credentials into the the secure storage only if validated
                                if (loggedIn) {
                                  Keychain().addCredentials(email, password);
                                  Navigator.pushNamed(context, '/main');
                                } else {
                                  //TODO:send back error message

                                }
                              },
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
