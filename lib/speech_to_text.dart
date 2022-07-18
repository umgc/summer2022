import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import './main.dart';

class Speech {
  SpeechToText speech = SpeechToText();
  String words = '';
  String input = '';
  bool speechEnabled = false;
  bool mute = false;

  String recording() {
    speech.listen(listenFor: const Duration(seconds: 5), onResult: result);
    return (words);
  }

  void result(SpeechRecognitionResult result) {
    words = result.recognizedWords;
  }

// The loop that allows for constant speech recognition
  Future<void> speechToText() async {
    speechEnabled = await speech.initialize();
    while (true) {
      input = recording();
      command(input);
      input = '';
      words = '';
      await Future.delayed(const Duration(seconds: 6));
    }
  }

// The commands that the user can utilise
  command(String s) {
    //General commands
    if (s == 'stop' && mute == false) {
    } else if (s == 'mute' && mute == false) {
      mute = true;
    } else if (s == 'unmute') {
      mute = false;
    } else if (s == 'speakers off' && mute == false) {
    } else if (s == 'speakers on' && mute == false) {
    } else if (s == 'back' && mute == false) {
      navKey.currentState!.pushNamed('/');
    }
    // Main menu commands
    else if (s == "today's mail" && mute == false) {
    } else if (s == 'unread mail' && mute == false) {
    } else if (s == 'email date' && mute == false) {
    } else if (s == 'settings' && mute == false) {
      navKey.currentState!.pushNamed('/settings');
    } else if (s == 'sign out' && mute == false) {
      navKey.currentState!.pushNamed('/sign_in');
    } else if (s == 'switch email' && mute == false) {
      navKey.currentState!.pushNamed('/other_mail');
    } else if (s == 'switch Digest' && mute == false) {
      navKey.currentState!.pushNamed('/digest_mail');
    } else if (s == 'menu help' && mute == false) {
    }
    // mail page commands
    else if (s == 'next' && mute == false) {
    } else if (s == 'previous' && mute == false) {
    } else if (s == 'next Digest' && mute == false) {
    } else if (s == 'previous Digest' && mute == false) {
    } else if (s == 'hyperlinks' && mute == false) {
    } else if (s == 'details' && mute == false) {
    } else if (s == 'mail help' && mute == false) {
    }
    // settings page commands
    else if (s == 'sender on' && mute == false) {
    } else if (s == 'sender off' && mute == false) {
    } else if (s == 'recipient on' && mute == false) {
    } else if (s == 'recipient off' && mute == false) {
    } else if (s == 'logos on' && mute == false) {
    } else if (s == 'logos off' && mute == false) {
    } else if (s == 'hyperlinks on' && mute == false) {
    } else if (s == 'hyperlinks off' && mute == false) {
    } else if (s == 'sender address on' && mute == false) {
    } else if (s == 'sender address off' && mute == false) {
    } else if (s == 'autoplay on' && mute == false) {
    } else if (s == 'autoplay off' && mute == false) {
    } else if (s == 'repeat' && mute == false) {
    } else if (s == 'settings help' && mute == false) {
    }
    // Sign in page commands
    else if (s == 'email address' && mute == false) {
    } else if (s == 'password' && mute == false) {
    } else if (s == 'login' && mute == false) {
    } else if (s == 'sign in help' && mute == false) {
    }
    // Wrong command
    else {}
  }
}
