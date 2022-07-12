import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/daily_digest_files.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io';

class ReadMail {
  bool dailyDigest;
  TextToSpeech tts;
  // TODO placeholder until we actually parse email
  var emailDetails = {'email_subject':'Checking in','email_text':'Hi, how are you?', 'email_sender':'myfriend@yahoo.com', 'email_recipients':'someemail@gmail.com'}; 

  ReadMail(this.dailyDigest, this.tts) {
    tts = TextToSpeech();  
  }

  void readDigestSender(MailObject mail){
    if (GlobalConfiguration().getValue("sender")) {
      String text = "The sender is '${mail.name}'";  
      tts.speak(text);  
    }
  }

  void readDigestRecipient(MailObject mail){
    if (GlobalConfiguration().getValue("recipient")) {
      String text = "The sender is '${mail.recipient}'";  
      tts.speak(text);  
    }
  }

  void readDigestAddress(MailObject mail){
    if (GlobalConfiguration().getValue("address")) {
      String text = "The address is '${mail.address}'";  
      tts.speak(text);  
    }
  }

  void readDigestLogos(List<LogoObject> logos){
    if (GlobalConfiguration().getValue("logos")) {
      for (LogoObject logo in logos) {
        String text = "The logo says '${logo.description.name}'";
        tts.speak(text);
      }
    }
  }

  void readDigestLinks(List<CodeObject> codeObject){
    if (GlobalConfiguration().getValue("links")) {
      for (CodeObject code in codeObject) {
        String text = "There is a link that is a '${code.codeType}'. The link is '${code.link}'. Would you like to go to the link?";
        tts.speak(text);
        // TODO.. needs to listen for response and then display link 
      }
    }
  }

  void readDigestValidated(MailObject mail){
    if (GlobalConfiguration().getValue("validated")) {
      String validated = "was not";

      if (mail.validated == "true") {
        validated = "was";
      }
      String text = "The address $validated validated";  
      tts.speak(text);  
    }
  }

  //subject text sender recipients

  void readEmailSubject(){
    if (GlobalConfiguration().getValue("email_subject")) {
      var subject = emailDetails["email_subject"];
      String text = "The email subject is $subject";
      if (subject != null) {
        tts.speak(text);
      } else {
        tts.speak("There is no email subject.");
      }
    }
  }

  void readEmailText(){
    if (GlobalConfiguration().getValue("email_text")) {
      var emailText = emailDetails["email_text"];
      String text = "The email text is $emailText";
      if (emailText != null) {
        tts.speak(text);
      } else {
        tts.speak("There is no email text.");
      }
    }
  }

  void readEmailSender(){
    if (GlobalConfiguration().getValue("email_sender")) {
      var sender = emailDetails["email_sender"];
      String text = "The email sender is $sender";
      if (sender != null) {
        tts.speak(text);
      } else {
        tts.speak("There is no email sender.");
      }
    }
  }

  void readEmailRecipients(){
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

  void readAllMailInfo() {
    if (dailyDigest) {
      DailyDigestFiles digest = DailyDigestFiles();
      List<DailyDigestFile> digestFiles = digest.getFiles();

      for (var digestFile in digestFiles) {
        for (var i = 0 ; i < digestFile.mailObjects.length; i++) {
            readDigestSender(digestFile.mailObjects[i]);
            readDigestRecipient(digestFile.mailObjects[i]);
            readDigestAddress(digestFile.mailObjects[i]);
            readDigestLogos(digestFile.logoObjects);
            readDigestLinks(digestFile.codeObjects);
            readDigestValidated(digestFile.mailObjects[i]);
          }
          if (GlobalConfiguration().getValue("autoplay")) {
            // TODO wait until user says next command
          } else {
            // Wait a few seconds before reading next mail
            sleep(const Duration(seconds: 5));
          }
      
      }
    } else { // Normal mail
      readEmailSubject();
      readEmailText();
      readEmailSender();
      readEmailRecipients();
    }
  }
}