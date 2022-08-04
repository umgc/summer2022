import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool micOn = true;
  bool speakerOn = true;
  double commonIconSize = 110;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        // MODE Dialog Box
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*
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
            */
            Padding(
              // MODE Dialog Box
              padding: const EdgeInsets.only(top: 0, bottom: 80, left: 25, right: 0),
              child: IconButton(
                  icon: Icon(Icons.help_outline, size: commonIconSize),
                  onPressed: () {
                    print("Say commands out loud");
                  }),
            ),
            const Spacer(),
            recordButton()
          ],
        ),
      ),
    );
  }

  GestureDetector recordButton() {
    return GestureDetector(
      onTapDown: (_) => print("Button pressed, Begin Recording"),// Begin Recording
      onTapUp: (_) {
        print("Button Un-pressed, Stop Recording");// stop recording
      },
      child: Padding(
    // MODE Dialog Box
        padding: const EdgeInsets.only(top: 5, bottom: 10, left: 0, right: 30),
        child: Icon(Icons.fiber_manual_record_rounded, size: commonIconSize + 10, color: Colors.red),
      )
    );
  }
}
