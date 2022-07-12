import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/daily_digest_files.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io';

class ReadMail {
  bool dailyDigest;
  TextToSpeech tts;

  ReadMail(this.dailyDigest, this.tts) {
    tts = TextToSpeech();  
  }

  void readMailInfo() {
    if (dailyDigest) {
      DailyDigestFiles digest = DailyDigestFiles();
      List<DailyDigestFile> digestFiles = digest.getFiles();

      for (var digestFile in digestFiles) {
        for (var i = 0 ; i < digestFile.mailObjects.length; i++) {
          if (GlobalConfiguration().getValue("sender")) {
            String text = "The sender is '${digestFile.mailObjects[i].name}'";  
              tts.speak(text);  
            }
            if (GlobalConfiguration().getValue("recipient")) {
              String text = "The sender is '${digestFile.mailObjects[i].recipient}'";  
              tts.speak(text);  
            }
            if (GlobalConfiguration().getValue("address")) {
              String text = "The address is '${digestFile.mailObjects[i].address}'";  
              tts.speak(text);  
            }
            if (GlobalConfiguration().getValue("logos")) {
              String text = "The logo says '${digestFile.logoObjects[i].description.name}'";
              tts.speak(text);
            }
            if (GlobalConfiguration().getValue("links")) {
              String text = "There is a link that is a '${digestFile.codeObjects[i].codeType}'. The link is '${digestFile.codeObjects[i].codeType}'. Would you like to go to the link?";
              tts.speak(text);
              // TODO.. needs to listen for response and then display link 
            }
            if (GlobalConfiguration().getValue("validated")) {
              String validated = "was not";

              if (digestFile.mailObjects[i].validated == "true") {
                validated = "was";
              }
              String text = "The address $validated validated";  
              tts.speak(text);  
            }
          }
          if (GlobalConfiguration().getValue("autoplay")) {
            // TODO wait until user says next command
          } else {
            // Wait a few seconds before reading next mail
            sleep(const Duration(seconds: 5));
          }
      
      }
    } else { // Normal mail
      // TODO placeholder until we actually parse email
      var emailDetails = {'email_subject':'Checking in','email_text':'Hi, how are you?', 'email_sender':'myfriend@yahoo.com', 'email_recipients':'someemail@gmail.com'}; 
      
      if (GlobalConfiguration().getValue("email_subject")) {
        var subject = emailDetails["email_subject"];
        String text = "The email subject is $subject";
        if (subject != null) {
          tts.speak(text);
        } else {
          tts.speak("There is no email subject.");
        }
      }
      if (GlobalConfiguration().getValue("email_text")) {
        var emailText = emailDetails["email_text"];
        String text = "The email text is $emailText";
        if (emailText != null) {
          tts.speak(text);
        } else {
          tts.speak("There is no email text.");
        }
      }
      if (GlobalConfiguration().getValue("email_sender")) {
        var sender = emailDetails["email_sender"];
        String text = "The email sender is $sender";
        if (sender != null) {
          tts.speak(text);
        } else {
          tts.speak("There is no email sender.");
        }
      }
      if (GlobalConfiguration().getValue("email_recipients")) {
        var recipients = emailDetails["email_recipients"];
        String text = "The email recipients are $recipients";
        if (recipients != null) {
          tts.speak(text);
        } else {
          tts.speak("There are no email recipients.");
        }
      }
    }
  }
}