import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summer2022/settings.dart';
import 'package:summer2022/main_menu.dart';

import 'mail_widget.dart';

void main() {
  runApp(MaterialApp(home: buildScreen()));
}

Widget buildScreen() {
  return Scaffold(
    body: MainWidget(),
    bottomNavigationBar: BottomAppBar(
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.volume_mute), onPressed: () {}),
          Spacer(),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          Spacer(),
          IconButton(icon: Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
    ),
  );
}
