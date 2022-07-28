import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../read_info.dart';
import '../speech_to_text.dart';

class BottomBar extends StatefulWidget {
  final String path;
  BottomBar(this.path, {Key? key}) : super(key: key);
  // const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool micOn = true;
  bool speakerOn = true;
  double commonIconSize = 65;
  String path = '';
  GlobalConfiguration cfg = GlobalConfiguration();

  @override
  Widget build(BuildContext context) {
    print(context.widget);
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
                    if (speakerOn) {
                      tts.setVolume(1.0);
                    } else {
                      tts.setVolume(0.0);
                    }
                  },
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                (cfg.getValue('muteMic')) ? Icons.mic_off : Icons.mic_none,
                size: commonIconSize,
              ),
              onPressed: () {
                setState(
                  () {
                    bool mic = cfg.getValue('muteMic');
                    cfg.updateValue('muteMic', !mic);
                    print(cfg.getValue('muteMic'));
                  },
                );
              },
            ),
            const Spacer(),
            IconButton(
                icon: Icon(Icons.help_outline, size: commonIconSize),
                onPressed: () {
                  print(widget.toString());
                  CommandTutorial().help((context.widget as BottomBar).path);
                }),
          ],
        ),
      ),
    );
  }
}
