import 'package:enough_mail/pop.dart';
import 'package:global_configuration/global_configuration.dart';
import './models/MailResponse.dart';
import './models/Address.dart';
import './models/Logo.dart';
import './models/Code.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

Future<void> _speak(String text) async {
  if (text.isNotEmpty) {
    await tts.awaitSpeakCompletion(true);
    await tts.speak(text);
  }
}

Future _stop() async {
  var result = await tts.stop();
}

void initTTS() async {
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
  late AddressObject sender;
  late AddressObject recipient;

  ReadDigestMail() {
    initTTS();
  }

  void setCurrentMail(MailResponse mail) {
    currentMail = mail;
    getSenderAndRecipient(currentMail.addresses);
    initTTS();
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

  // Use this function if you want to read all the details. If you want a specific detail, use the other functions
  void readDigestInfo() {
    if (GlobalConfiguration().getValue("sender") == true) {
      readDigestSenderName();
    }
    if (GlobalConfiguration().getValue("recipient") == true) {
      readDigestRecipientName();
    }
    if (GlobalConfiguration().getValue("validated") == true) {
      readDigestSenderAddressValidated();
      readDigestRecipientAddressValidated();
    }
    if (GlobalConfiguration().getValue("address") == true) {
      readDigestSenderAddress();
      readDigestRecipientAddress();
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
    String text = "The sender is '${sender.name}'";
    _speak(text);
  }

  void readDigestRecipientName() {
    /* Get the name of the recipient */
    String text = "The sender is '${recipient.name}'";
    _speak(text);
  }

  void readDigestSenderAddress() {
    /* Get the sender's address */
    String text = "The sender's address is '${sender.address}'";
    _speak(text);
  }

  void readDigestRecipientAddress() {
    /* Get the recipient's address */
    String text = "The recipient's address is '${recipient.address}'";
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
    for (CodeObject code in currentMail.codes) {
      String text =
          "There is a link that is a '${code.type}'. The link is '${code.info}'. Would you like to go to the link?";
      _speak(text);
      // TODO.. needs to listen for response and then display link
    }
  }

  void readDigestSenderAddressValidated() {
    /* Get if the sender's address was validated */
    String validated = "was not";

    if (sender.validated) {
      validated = "was";
    }
    String text = "The sender's address $validated validated";
    _speak(text);
  }

  void readDigestRecipientAddressValidated() {
    /* Get if the recipient's address was validated */
    String validated = "was not";
    if (recipient.validated) {
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
    recipients[-1] = "and ${recipients[-1]}";
    recipients.join(', ');
    String text = "The email recipients are $recipients";
    if (recipients.isNotEmpty) {
      _speak(text);
    } else {
      _speak("There are no email recipients.");
    }
  }
}
