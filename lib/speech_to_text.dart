import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:summer2022/read_info.dart';
import 'package:summer2022/ui/mail_widget.dart';

import './main.dart';
import 'ui/settings.dart';

class Speech {
  String currentPage = "settings";
  SpeechToText speech = SpeechToText();
  String words = '';
  String input = '';
  bool speechEnabled = false;
  bool mute = false;
  ReadDigestMail digestMail = ReadDigestMail();
  ReadMail mail = ReadMail();

  void setCurrentPage(String page) {
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
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              state.seekForward();
              break;
            case 'previous':
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              state.seekBack();
              break;
            case 'next Digest':
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              state.setState(() {
                state.seekForward();
              });
              break;
            case 'previous Digest':
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              state.setState(() {
                state.seekBack();
              });
              break;
            case 'hyperlinks':
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              var links = state.widget.digest.links;
              links.forEach((link) {
                //TODO need a way to read links from Digest and prompt the user to open the link
                var open = false; //replace this with an actual true false
                if(open) {
                  state.openLink(link.link);
                }
              });
              break;
            case 'details':
              var state = (navKey.currentWidget as MailWidget).state as MailWidgetState;
              state.readMailPiece();
              break;
            default:
              break;
          }
          break;
        case 'email':
          switch(s) {
            // mail page commands
            case 'next':
              break;
            case 'previous':
              break;
            case 'next Digest':
              break;
            case 'previous Digest':
              break;
            case 'hyperlinks':
              break;
            case 'details':
              break;
            default:
              break;
          }
          break;
        // Main menu commands
        case 'main':
          switch (s) {
            case "today's mail":
              break;
            case 'unread mail':
              break;
            case 'email date':
              break;
            case 'settings':
              navKey.currentState!.pushNamed('/settings');
              break;
            case 'sign out':
              navKey.currentState!.pushNamed('/sign_in');
              break;
            case 'switch email':
              navKey.currentState!.pushNamed('/other_mail');
              break;
            case 'switch Digest':
              navKey.currentState!.pushNamed('/digest_mail');
              break;
            case 'menu help':
              break;
            default:
              break;
          }
          break;
        // settings page commands
        case 'settings':
          switch (s) {
            case 'send her on':
              cfg.updateValue("sender", true);
              break;
            case 'send her off':
              cfg.updateValue("sender", false);
              break;
            case 'recipient on':
              cfg.updateValue("recipient", true);
              break;
            case 'recipient off':
              cfg.updateValue("recipient", false);
              break;
            case 'logos on':
              cfg.updateValue("logos", true);
              break;
            case 'logos off':
              cfg.updateValue("logos", false);
              break;
            case 'hyperlinks on':
              cfg.updateValue("links", true);
              break;
            case 'hyperlinks off':
              cfg.updateValue("links", false);
              break;
            case 'address on':
              cfg.updateValue("address", true);
              break;
            case 'address off':
              cfg.updateValue("address", false);
              break;
            case 'email subject on':
              cfg.updateValue("email_subject", true);
              break;
            case 'email subject off':
              cfg.updateValue("email_subject", false);
              break;
            case 'email text on':
              cfg.updateValue("email_text", true);
              break;
            case 'email text off':
              cfg.updateValue("email_text", false);
              break;
            case 'email sender address on':
              cfg.updateValue("email_sender", true);
              break;
            case 'email sender address off':
              cfg.updateValue("email_sender", false);
              break;
            case 'email recipients on':
              cfg.updateValue("email_recipients", true);
              break;
            case 'email recipients off':
              cfg.updateValue("email_recipients", false);
              break;
            case 'autoplay on':
              break;
            case 'autoplay off':
              break;
            case 'repeat':
              break;
            case 'settings help':
              break;
            default:
              break;
          }
          break;
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
      }
      // General commands
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
    }
  }
}
