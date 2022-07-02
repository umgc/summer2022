import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summer2022/settings.dart';
import 'package:summer2022/main_menu.dart';
import 'package:summer2022/sign_in.dart';

import 'RouteGenerator.dart';
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
    bottomNavigationBar: BottomAppBar(
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.volume_mute, size: 30), onPressed: () {}),
          Spacer(),
          IconButton(
              icon: Icon(Icons.mic_external_on, size: 30), onPressed: () {}),
          Spacer(),
          IconButton(
              icon: Icon(Icons.help_outline, size: 30), onPressed: () {}),
        ],
      ),
    ),
  );
}
