import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/Logo.dart';
import 'package:summer2022/models/Code.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

Future<void> _speak(String text) async {
  if (text != null && text.isNotEmpty) {
    print(text);
    await tts.speak(text);
    if(Platform.isAndroid) {
      //currently this feature is only supported by android
      await tts.awaitSpeakCompletion(true);
    }
  }
}

Future _stop() async {
    var result = await tts.stop();
}

void initTTS() async {
  await tts.setLanguage("en-US");
  await tts.setSpeechRate(0.5); //slower speeds are easier to comprehend
  await tts.setVolume(1.0);
  await tts.setPitch(1.0);
  await tts.setQueueMode(1); // this needs to be set to queue_add or it will not function correctly
}

/*
 * The ReadDigestMail class's purpose is to read the details of a Daily Digest mail 
 */
class ReadDigestMail {
  MailResponse currentMail;
  AddressObject? sender;
  AddressObject? recipient;
  
  ReadDigestMail(this.currentMail) {
    getSenderAndRecipient(currentMail.addresses);
    initTTS();
  }

  void getSenderAndRecipient(List<AddressObject> addresses) {
    /* This code is assuming that there is one address object for the sender
       and one for the recipient. Figure out which one is which. */
    //it is not safe to assume that there is always a sender and/or recipient on the attachment or that it can be properly interpreted
    for(int x = 0; x < addresses.length; x++) {
      if(addresses[x].type == "sender" && sender == null) {
        sender = addresses[x];
      } else if(addresses[x].type == "recipient" && recipient == null) {
        recipient = addresses[x];
      }
    }
    //if (addresses[0].type == "sender") {
    //    sender = addresses[0];
    //    recipient = addresses[1];
    //  } else {
    //    sender = addresses[0];
    //    recipient = addresses[1];
    //  }
      //return [sender, recipient];
  }

  void stop() {
    _stop();
  }

  // Use this function if you want to read all the details. If you want a specific detail, use the other functions
  void readDigestInfo() {
    stop(); //need to call stop so we are not queueing lines infinitely for things that are no longer relevant
    if (GlobalConfiguration().getValue("sender") == true && sender != null) {
      readDigestSenderName();
    }
    if (GlobalConfiguration().getValue("recipient") == true && recipient != null) {
      readDigestRecipientName();
    }
    if (GlobalConfiguration().getValue("validated") == true) {
      if(sender != null) {
        readDigestSenderAddressValidated();
      }
      if(recipient != null) {
        readDigestRecipientAddressValidated();
      }
    }
    if (GlobalConfiguration().getValue("address") == true) {
      if(sender != null) {
        readDigestSenderAddress();
      }
      if(recipient != null) {
        readDigestRecipientAddress();
      }
    }
    if (GlobalConfiguration().getValue("logos") == true) {
      readDigestLogos();
    }
    if (GlobalConfiguration().getValue("links") == true) {
      readDigestLinks();
    }
  }

  void readDigestSenderName(){
    /* Get the name of the sender */
    String text = "The sender is '${sender!.name}'";
    _speak(text);        

  }

  void readDigestRecipientName() {
    /* Get the name of the recipient */
    String text = "The recipient is '${recipient!.name}'";
    _speak(text);  
  }

  void readDigestSenderAddress(){
    /* Get the sender's address */
    String text = "The sender's address is '${sender!.address}'";
    _speak(text);  
  }

  void readDigestRecipientAddress(){
    /* Get the recipient's address */
    String text = "The recipient's address is '${recipient!.address}'";
    _speak(text);  
  }

  void readDigestLogos(){
    /* Get the logos */
    for (LogoObject logo in currentMail.logos) {
      String text = "The logo says '${logo.name}'";
      _speak(text);
    }
  }

  void readDigestLinks(){
    /* Get the links */
    for (CodeObject code in currentMail.codes) {
      String text = "There is a link that is a '${code.type}'. The link is '${code.info}'. Would you like to go to the link?";
      _speak(text);
      // TODO.. needs to listen for response and then display link 
    }
  }

  void readDigestSenderAddressValidated(){
    /* Get if the sender's address was validated */
    String validated = "was not";

    if (sender!.validated) {
      validated = "was";
    }
    String text = "The sender's address $validated validated";  
    _speak(text);  
  }

  void readDigestRecipientAddressValidated(){
    /* Get if the recipient's address was validated */
    String validated = "was not";
    if (recipient!.validated) {
      validated = "was";
    }
    String text = "The recipient's address $validated validated";  
    _speak(text);  
  }
}

/*
 * The ReadMail class's purpose is to read the details of an email that is not a Daily Digest 
 */
class ReadMail {
  // TODO placeholder until we actually parse email
  var emailDetails = {'email_subject':'Checking in','email_text':'Hi, how are you?', 'email_sender':'myfriend@yahoo.com', 'email_recipients':'someemail@gmail.com'}; 

  ReadMail() {
    initTTS();
  }

  // Use this function if you want to read all the details. If you want a specific detail, use the other functions
  void readEmailInfo() {
    if (GlobalConfiguration().getValue("email_subject") == true) {
      readEmailSubject();
    }
    if (GlobalConfiguration().getValue("email_text") == true) {
      readEmailText();
    }
    if (GlobalConfiguration().getValue("email_sender") == true) {
      readEmailSender();
    }
    if (GlobalConfiguration().getValue("email_recipients") == true) {
      readEmailRecipients();
    }
  }

  void readEmailSubject(){
    var subject = emailDetails["email_subject"];
    String text = "The email subject is $subject";
    if (subject != null) {
      _speak(text);
    } else {
      _speak("There is no email subject.");
    }
  }

  void readEmailText(){
    var emailText = emailDetails["email_text"];
    String text = "The email text is $emailText";
    if (emailText != null) {
      _speak(text);
    } else {
      _speak("There is no email text.");
    }
  }

  void readEmailSender(){
    var sender = emailDetails["email_sender"];
    String text = "The email sender is $sender";
    if (sender != null) {
      _speak(text);
    } else {
      _speak("There is no email sender.");
    }
  }

  void readEmailRecipients(){
    var recipients = emailDetails["email_recipients"];
    String text = "The email recipients are $recipients";
    if (recipients != null) {
      _speak(text);
    } else {
      _speak("There are no email recipients.");
    }
  }
}