import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/Logo.dart';
import 'package:summer2022/models/Code.dart';
import 'package:text_to_speech/text_to_speech.dart';


/*
 * The ReadDigestMail class's purpose is to read the details of a Daily Digest mail 
 */
class ReadDigestMail {
  TextToSpeech tts;
  MailResponse currentMail;
  late AddressObject sender;
  late AddressObject recipient;
  
  ReadDigestMail(this.tts, this.currentMail) {
    tts = TextToSpeech();  
    getSenderAndRecipient(currentMail.addresses);
  }

  List<AddressObject> getSenderAndRecipient(List<AddressObject> addresses) {
    /* This code is assuming that there is one address object for the sender
       and one for the recipient. Figure out which one is which. */
    if (addresses[0].type == "sender") {
      sender = addresses[0];
      recipient = addresses[1];
    } else {
      sender = addresses[0];
      recipient = addresses[1];
    }
    return [sender, recipient];
  }

  void readDigestSenderName(){
    /* Get the name of the sender */
    if (GlobalConfiguration().getValue("sender")) {
      String text = "The sender is '${sender.name}'";  
      tts.speak(text);  
    }
  }

  void readDigestRecipientName() {
    /* Get the name of the recipient */
    if (GlobalConfiguration().getValue("recipient")) {
      String text = "The sender is '${recipient.name}'";  
      tts.speak(text);  
    }
  }

  void readDigestSenderAddress(){
    /* Get the sender's address */
    if (GlobalConfiguration().getValue("address")) {
      String text = "The sender's address is '${sender.address}'";  
      tts.speak(text);  
    }
  }

  void readDigestRecipientAddress(){
    /* Get the recipient's address */
    if (GlobalConfiguration().getValue("address")) {
      String text = "The recipient's address is '${recipient.address}'";  
      tts.speak(text);  
    }
  }

  void readDigestLogos(){
    /* Get the logos */
    if (GlobalConfiguration().getValue("logos")) {
      for (LogoObject logo in currentMail.logos) {
        String text = "The logo says '${logo.name}'";
        tts.speak(text);
      }
    }
  }

  void readDigestLinks(){
    /* Get the links */
    if (GlobalConfiguration().getValue("links")) {
      for (CodeObject code in currentMail.codes) {
        String text = "There is a link that is a '${code.type}'. The link is '${code.info}'. Would you like to go to the link?";
        tts.speak(text);
        // TODO.. needs to listen for response and then display link 
      }
    }
  }

  void readDigestSenderAddressValidated(){
    /* Get if the sender's address was validated */
    if (GlobalConfiguration().getValue("validated")) {
      String validated = "was not";

      if (sender.validated) {
        validated = "was";
      }
      String text = "The sender's address $validated validated";  
      tts.speak(text);  
    }
  }

  void readDigestRecipientAddressValidated(){
    /* Get if the recipient's address was validated */
    if (GlobalConfiguration().getValue("validated")) {
      String validated = "was not";
      if (recipient.validated) {
        validated = "was";
      }
      String text = "The recipient's address $validated validated";  
      tts.speak(text);  
    }
  }
}

/*
 * The ReadMail class's purpose is to read the details of an email that is not a Daily Digest 
 */
class ReadMail {
  TextToSpeech tts;
  // TODO placeholder until we actually parse email
  var emailDetails = {'email_subject':'Checking in','email_text':'Hi, how are you?', 'email_sender':'myfriend@yahoo.com', 'email_recipients':'someemail@gmail.com'}; 

  ReadMail(this.tts) {
    tts = TextToSpeech();  
  }

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

}