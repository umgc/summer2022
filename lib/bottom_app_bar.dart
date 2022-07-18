import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool micOn = true;
  bool speakerOn = true;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              (speakerOn == true)
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_rounded,
              size: 30,
            ),
            onPressed: () {
              setState(
                () {
                  speakerOn = !speakerOn;
                },
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              (micOn == true) ? Icons.mic_none : Icons.mic_off,
              size: 30,
            ),
            onPressed: () {
              setState(
                () {
                  micOn = !micOn;
                },
              );
            },
          ),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.help_outline, size: 30),
              onPressed: () {
                print("Say commands out loud");
              }),
        ],
      ),
    );
  }
}
