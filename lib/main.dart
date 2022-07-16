import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './Client.dart';
import './keychain.dart';
import './settings.dart';
import './main_menu.dart';
import './sign_in.dart';

import 'RouteGenerator.dart';
import 'bottom_app_bar.dart';
import 'mail_widget.dart';
import 'other_mail.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // needed to access Keychain prior to main finishing
  var email_authenticated = false; // default false go to signin page
  String? username = await Keychain().getUsername();
  String? password = await Keychain().getPassword();
  if (username != null && password != null) {
    email_authenticated = (await Client().getImapClient(
        username, password)); //Replace with config read for credentials
  }

  runApp(MaterialApp(
      title: "USPS Infromed Delivery Visual Assistance App",
      initialRoute: email_authenticated == true ? "/main" : "/sign_in",
      onGenerateRoute: RouteGenerator.generateRoute,
      home: buildScreen(email_authenticated)));
}

Widget buildScreen(bool email_authenticated) {
  return Scaffold(
    body: email_authenticated == true ? MainWidget() : SignInWidget(),
    bottomNavigationBar: BottomBar(),
  );
}
