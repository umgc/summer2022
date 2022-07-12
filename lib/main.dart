// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import './settings.dart';
import './main_menu.dart';
import './sign_in.dart';

import 'RouteGenerator.dart';
import 'bottom_app_bar.dart';
import 'mail_widget.dart';
import 'other_mail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration cfg = GlobalConfiguration();
  await cfg.loadFromAsset("app_settings");
  runApp(MaterialApp(
      title: "USPS Infromed Delivery Visual Assistance App",
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: buildScreen()));
}

Widget buildScreen() {
  return const Scaffold(
    body: MainWidget(),
    bottomNavigationBar: BottomBar(),
  );
}
