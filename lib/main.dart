// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:summer2022/Client.dart';
import 'package:summer2022/Keychain.dart';
import 'package:summer2022/speech_to_text.dart';
import 'package:summer2022/ui/main_menu.dart';
import 'package:summer2022/ui/sign_in.dart';
import 'RouteGenerator.dart';
import 'package:summer2022/ui/bottom_app_bar.dart';
import 'dart:io' show Platform, sleep;

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
final Speech stt = Speech();
FlutterTts tts = FlutterTts();
enum TtsState { playing, stopped, paused, continued }
TtsState ttsState = TtsState.stopped;

Future speak(String text) async {
  try {
  await tts.awaitSpeakCompletion(true);
  bool result = await tts.speak(text);
  print("result $result");
  } catch(e) {
    print(e.toString());
  }
}

Future stop() async {
  await tts.stop();
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // needed to access Keychain prior to main finishing
  GlobalConfiguration cfg = GlobalConfiguration();
  await cfg.loadFromAsset("app_settings");
  var emailAuthenticated = false; // default false go to signin page
  String? username = await Keychain().getUsername();
  String? password = await Keychain().getPassword();
  if (username != null && password != null) {
    emailAuthenticated = (await Client().getImapClient(
        username, password)); //Replace with config read for credentials
  }

  void initTTS() async {
    if(Platform.isAndroid) {
      await tts.setQueueMode(1);
    }
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(.4);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
  }

  initTTS();

  setTtsState(TtsState state) {
    print("set tts state $state");
    ttsState = state;
  }

  tts.setStartHandler(() {
    setTtsState(TtsState.playing);
  });

  tts.setCompletionHandler(() {
    setTtsState(TtsState.stopped);
  });

  stt.speechToText();

  runApp(GlobalLoaderOverlay(
      child: MaterialApp(
    title: "USPS Informed Delivery Visual Assistance App",
    initialRoute: emailAuthenticated == true ? "/main" : "/sign_in",
    onGenerateRoute: RouteGenerator.generateRoute,
    home: buildScreen(emailAuthenticated),
    navigatorKey: navKey,
  )));
}

Widget buildScreen(bool emailAuthenticated) {
  return Scaffold(
    body:
        emailAuthenticated == true ? const MainWidget() : const SignInWidget(),
    bottomNavigationBar: const BottomBar(),
  );
}
