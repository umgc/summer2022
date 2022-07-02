import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool mic_on = true;
  bool speaker_on = true;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              (speaker_on == true)
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_rounded,
              size: 30,
            ),
            onPressed: () {
              setState(
                () {
                  speaker_on = !speaker_on;
                },
              );
            },
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              (mic_on == true) ? Icons.mic_none : Icons.mic_off,
              size: 30,
            ),
            onPressed: () {
              setState(
                () {
                  mic_on = !mic_on;
                },
              );
            },
          ),
          Spacer(),
          IconButton(
              icon: Icon(Icons.help_outline, size: 30),
              onPressed: () {
                print("Say commands out loud");
              }),
        ],
      ),
    );
  }
}
