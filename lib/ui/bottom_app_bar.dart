import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool micOn = true;
  bool speakerOn = true;
  double commonIconSize = 65;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        // MODE Dialog Box
        padding: EdgeInsets.only(top: 5, bottom: 25, left: 15, right: 40),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                (speakerOn == true)
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_rounded,
                size: commonIconSize,
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
                size: commonIconSize,
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
                icon: Icon(Icons.help_outline, size: commonIconSize),
                onPressed: () {
                  print("Say commands out loud");
                }),
          ],
        ),
      ),
    );
  }
}
