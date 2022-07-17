import 'package:text_to_speech/text_to_speech.dart';

class CommandTutorial {
  late TextToSpeech tts;

  String skipTutorial = "To skip the voice command tutorial this time, say skip";
  String stopTutorial = "To turn off the voice command tutorial so it does not play at startup, say off";
  String stop = "To stop the current audio content, say stop";
  String back = "To go back to the previous page, say back";
  String next = "To go to the next item when reading mail or email, say next";
  String previous = "To go to the previous item when reading mail or email, say previous";
  String settings = "To change the default application settings, say settings";
  String mailDate = "To get mail for a specific date, say mail followed by the date";
  String emailDate = "To get emails for a specific date, say email followed by the date";
  String mailLatest = "To get the latest mail, say mail latest";
  String emailLatest = "To get the latest email, say email latest";
  String unreadMail = "To get mail you have no listened to yet, say mail unread";
  String unreadEmail = "To get emails you have no listened to yet, say email unread";
  String help = "To hear this voice command anytime, say help";

  ReadDigestMail() {
    tts = TextToSpeech();  
  }

  void runTutorial() {
    String tutorial = '''$skipTutorial $stopTutorial $stop $back $next $previous $settings
                         $mailDate $emailDate $mailLatest $emailLatest $unreadMail $unreadEmail $help''';
    tts.speak(tutorial);
  }

}