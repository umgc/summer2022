import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import './main.dart';
import './settings.dart';

class Speech {
  late String currentPage;
  SpeechToText speech = SpeechToText();
  String words = '';
  String input = '';
  bool speechEnabled = false;
  bool mute = false;

  Speech(String page) {
    currentPage = page;
  }

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
      print(input);
      command(input);
      input = '';
      words = '';
      await Future.delayed(const Duration(seconds: 6));
    }
  }

// The commands that the user can utilise
  command(String s) {
    //General commands
    if (s == 'unmute') {
        mute = false;
        return;
    } 
    if (mute == false){
      switch (currentPage) {
        case 'mail':
          switch(s) {
            // mail page commands
            case 'next':
              continue alsoGeneral;
            case 'previous':
              continue alsoGeneral;
            case 'next Digest':
              continue alsoGeneral;
            case 'previous Digest':
              continue alsoGeneral;
            case 'hyperlinks':
              continue alsoGeneral;
            case 'details':
              continue alsoGeneral;
            default:
                continue alsoGeneral;
          }
        case 'email':
          switch(s) {
            // mail page commands
            case 'next':
              continue alsoGeneral;
            case 'previous':
              continue alsoGeneral;
            case 'next Digest':
              continue alsoGeneral;
            case 'previous Digest':
              continue alsoGeneral;
            case 'hyperlinks':
              continue alsoGeneral;
            case 'details':
              continue alsoGeneral;
            default:
              continue alsoGeneral;
          }
        // Main menu commands
        case 'main':
          switch (s) {
            case "today's mail":
              continue alsoGeneral;
            case 'unread mail':
              continue alsoGeneral;
            case 'email date':
              continue alsoGeneral;
            case 'settings':
              navKey.currentState!.pushNamed('/settings');
              continue alsoGeneral;
            case 'sign out':
              navKey.currentState!.pushNamed('/sign_in');
              continue alsoGeneral;
            case 'switch email':
              navKey.currentState!.pushNamed('/other_mail');
              continue alsoGeneral;
            case 'switch Digest':
              navKey.currentState!.pushNamed('/digest_mail');
              continue alsoGeneral;
            case 'menu help':
              continue alsoGeneral;
            default:
              continue alsoGeneral;
          }
        // settings page commands
        case 'settings':
          switch (s) {
            case 'send her on':
              cfg.updateValue("sender", true);
              continue alsoGeneral;
            case 'send her off':
              cfg.updateValue("sender", false);
              continue alsoGeneral;
            case 'recipient on':
              cfg.updateValue("recipient", true);
              continue alsoGeneral;
            case 'recipient off':
              cfg.updateValue("recipient", false);
              continue alsoGeneral;
            case 'logos on':
              cfg.updateValue("logos", true);
              continue alsoGeneral;
            case 'logos off':
              cfg.updateValue("logos", false);
              continue alsoGeneral;
            case 'hyperlinks on':
              cfg.updateValue("links", true);
              continue alsoGeneral;
            case 'hyperlinks off':
              cfg.updateValue("links", false);
              continue alsoGeneral;
            case 'address on':
              cfg.updateValue("address", true);
              continue alsoGeneral;
            case 'address off':
              cfg.updateValue("address", false);
              continue alsoGeneral;
            case 'email subject on':
              cfg.updateValue("email_subject", true);
              continue alsoGeneral;
            case 'email subject off':
              cfg.updateValue("email_subject", false);
              continue alsoGeneral;
            case 'email text on':
              cfg.updateValue("email_text", true);
              continue alsoGeneral;
            case 'email text off':
              cfg.updateValue("email_text", false);
              continue alsoGeneral;
            case 'email sender address on':
              cfg.updateValue("email_sender", true);
              continue alsoGeneral;
            case 'email sender address off':
              cfg.updateValue("email_sender", false);
              continue alsoGeneral;
            case 'email recipients on':
              cfg.updateValue("email_recipients", true);
              continue alsoGeneral;
            case 'email recipients off':
              cfg.updateValue("email_recipients", false);
              continue alsoGeneral;
            case 'autoplay on':
              continue alsoGeneral;
            case 'autoplay off':
              continue alsoGeneral;
            case 'repeat':
              continue alsoGeneral;
            case 'settings help':
              continue alsoGeneral;
            default:
              continue alsoGeneral;
          }
        case 'signIn':
          switch (s) {
            // Sign in page commands
            case 'email address':
              break;
            case 'password':
              break;
            case 'login':
              break;
            case 'sign in help':
              break;
            default: // Invalid command
              break;
          }
          break;
        alsoGeneral:
          default:
            switch (s) {
              case 'mail help':
                break;
              case 'mute':
                mute = true;
                break;
              case 'stop' :
                break;
              case 'speakers off':
                break;
              case 'speakers on':
                break;
              case 'back':
                navKey.currentState!.pushNamed('/');
                break;
              default: // Invalid command
                break;
            }
            break;
      }
    }
  }
}
