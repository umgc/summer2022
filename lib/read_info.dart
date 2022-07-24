import 'package:enough_mail/pop.dart';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import './models/MailResponse.dart';
import './models/Address.dart';
import './models/Logo.dart';
import './models/Code.dart';
import './models/Digest.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

Future<void> _speak(String text) async {
  if (text.isNotEmpty) {
    await tts.awaitSpeakCompletion(true);
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
  if(Platform.isAndroid) {
    await tts.setQueueMode(1);
  }
  await tts.setLanguage("en-US");
  await tts.setSpeechRate(1.0);
  await tts.setVolume(1.0);
  await tts.setPitch(1.0);
}

/*
 * The ReadDigestMail class's purpose is to read the details of a Daily Digest mail 
 */
class ReadDigestMail {
  late MailResponse currentMail;
  AddressObject? sender;
  AddressObject? recipient;
  List<Link> links = <Link>[];
  
  ReadDigestMail() {
    initTTS();
  }

  void setCurrentMail(MailResponse mail) {
    currentMail = mail;
    setSenderAndRecipient(currentMail.addresses);
    initTTS();
  }

  void setSenderAndRecipient(List<AddressObject> addresses) {
    sender = null;
    recipient = null;
    for(int x = 0; x < addresses.length; x++) {
      if(addresses[x].type == "sender" && sender == null) {
        sender = addresses[x];
      } else if(addresses[x].type == "recipient" && recipient == null) {
        recipient = addresses[x];
      }
    }
  }

  List<AddressObject> getSenderAndRecipient() {
    /* This code is assuming that there is one address object for the sender
       and one for the recipient. Figure out which one is which. */
    //if (addresses[0].type == "sender") {
    //  sender = addresses[0];
    //  recipient = addresses[1];
    //} else {
    //  sender = addresses[0];
    //  recipient = addresses[1];
    //}
    return [sender!, recipient!];
  }

  // Use this function if you want to read all the details. If you want a specific detail, use the other functions
  void readDigestInfo() {
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

  void readDigestSenderName() {
    /* Get the name of the sender */
    String text = "The sender is '${sender!.name}'";
    _speak(text);

  }

  void readDigestRecipientName() {
    /* Get the name of the recipient */
    String text = "The recipient is '${recipient!.name}'";
    _speak(text);
  }

  void readDigestSenderAddress() {
    /* Get the sender's address */
    String text = "The sender's address is '${sender!.address}'";
    _speak(text);
  }

  void readDigestRecipientAddress() {
    /* Get the recipient's address */
    String text = "The recipient's address is '${recipient!.address}'";
    _speak(text);
  }

  void readDigestLogos() {
    /* Get the logos */
    for (LogoObject logo in currentMail.logos) {
      String text = "The logo says '${logo.name}'";
      _speak(text);
    }
  }

  void readDigestLinks() {
    /* Get the links */
    for (Link code in links) {
//      String text = "There is a link that is a '${code.type}'. The link is '${code.info}'. Would you like to go to the link?";
      String text = "TThe link is '${code.link}'. Would you like to go to the link?";
      _speak(text);
      // TODO.. needs to listen for response and then display link
    }
  }

  void readDigestSenderAddressValidated() {
    /* Get if the sender's address was validated */
    String validated = "was not";

    if (sender!.validated) {
      validated = "was";
    }
    String text = "The sender's address $validated validated";
    _speak(text);
  }

  void readDigestRecipientAddressValidated() {
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
  late MimeMessage currentMail;

  ReadMail() {
    initTTS();
  }

  void setCurrentMail(MimeMessage mail) {
    currentMail = mail;
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
    var subject = currentMail.decodeSubject();
    String text = "The email subject is $subject";
    if (subject != null) {
      _speak(text);
    } else {
      _speak("There is no email subject.");
    }
  }

  void readEmailText(){
    var emailText = currentMail.body;
    String text = "The email text is $emailText";
    if (emailText != null) {
      _speak(text);
    } else {
      _speak("There is no email text.");
    }
  }

  void readEmailSender(){
    var sender = currentMail.decodeSender();
    String text = "The email sender is $sender";
    if (sender != null) {
      _speak(text);
    } else {
      _speak("There is no email sender.");
    }
  }

  void readEmailRecipients(){
    List<String?> recipients = [];
    for (MailAddress recipient in currentMail.recipients) {
      if (recipient.hasPersonalName) {
        recipients.add(recipient.personalName);
      } else {
        recipients.add(recipient.mailboxName);
      }
    }
    if (recipients.length > 1) { // Fix for grammar
      recipients[recipients.length-1] = "and ${recipients[recipients.length-1]}";
    }
    recipients.join(', ');
    if (recipients.isNotEmpty) {
      String? recipientsString = recipients[0];
      String text = "The email recipients are $recipientsString";
      _speak(text);
    } else {
      _speak("There are no email recipients.");
    }
  }
}
