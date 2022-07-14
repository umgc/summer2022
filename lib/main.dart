import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './settings.dart';
import './main_menu.dart';
import './sign_in.dart';

import 'RouteGenerator.dart';
import 'bottom_app_bar.dart';
import 'mail_widget.dart';
import 'other_mail.dart';

void main() {
  runApp(MaterialApp(
      title: "USPS Infromed Delivery Visual Assistance App",
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: buildScreen()));
}

Widget buildScreen() {
  return Scaffold(
    body: MainWidget(),
    bottomNavigationBar: BottomBar(),
  );
}
