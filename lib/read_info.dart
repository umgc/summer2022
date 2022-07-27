import 'package:enough_mail/pop.dart';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/Logo.dart';
import 'package:summer2022/models/Digest.dart';
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
  if(Platform.isAndroid) {
    await tts.setQueueMode(1);
  }
  await tts.setLanguage("en-US");
  await tts.setSpeechRate(.4);
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

  void stop() {
    _stop();
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
      String text = "The link is '${code.info != "" ? code.info : code.link}'. Would you like to go to the link?";
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

  void stop() {
    _stop();
  }

  void setCurrentMail(MimeMessage mail) {
    currentMail = mail;
  }

  // Use this function if you want to read all the details. If you want a specific detail, use the other functions
  Future<void> readEmailInfo() async {
    if (GlobalConfiguration().getValue("email_subject") == true) {
      await readEmailSubject();
    }
    if (GlobalConfiguration().getValue("email_text") == true) {
      await readEmailText();
    }
    if (GlobalConfiguration().getValue("email_sender") == true) {
      await readEmailSender();
    }
    if (GlobalConfiguration().getValue("email_recipients") == true) {
      await readEmailRecipients();
    }
  }

  Future<void> readEmailSubject() async {
    var subject = currentMail.decodeSubject();
    String text = "The email subject is $subject";
    if (subject != null) {
      await _speak(text);
    } else {
      await _speak("There is no email subject.");
    }
  }

  Future<void> readEmailText() async {
    var emailText = currentMail.body;
    String text = "The email text is $emailText";
    if (emailText != null) {
      await _speak(text);
    } else {
      await _speak("There is no email text.");
    }
  }

  Future<void> readEmailSender() async {
    var sender = currentMail.decodeSender();
    String text = "The email sender is $sender";
    if (sender != null) {
      await _speak(text);
    } else {
      await _speak("There is no email sender.");
    }
  }

  Future<void> readEmailRecipients() async {
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
      await _speak(text);
    } else {
      await _speak("There are no email recipients.");
    }
  }
}

class CommandTutorial {
  bool ranTutorial = false;

  CommandTutorial() {
    initTTS();
  }

  String tutorial =
    '''
    Welcome to the USPS Visual Assistance App.
    To skip the voice command tutorial this time, say skip.
    To turn off the voice command tutorial so it does not play at startup, say off.
    Currently you are on the main page. You can navigate to the Digest page, Email page, and settings through a series of commands.
    ''';

  String main =
    '''
    To sign out of your account, say sign out.
    To navigate to the settings page, say settings.
    ''';

  String digest =
    '''
    To navigate to the digest page, there are two voice command options.
    Option 1 is to get the latest digest, by saying latest digest.
    Option 2 is to get a digest for a specific date, by saying digest date followed by the date.
    ''';

  String email =
    '''
    To navigate to the email page, there are three voice command options.
    Option 1 is to get emails for a specific date, by saying email date followed by the date.
    Option 2 is to get the latest email, by saying latest email.
    Option 3 is to get emails you have not listened to yet, by saying unread email.
    ''';

  String digestAndEmail =
    '''
    When requesting digests or emails for a specific date, the date formatting is month, day, year.
    An example is June 10th 2022.
    When listening to digests or emails, say next to go to the next item.
    When listening to digests or emails, say previous to go to the previous item.
    While on the digest or email page, to get all of the details for the current email or digest, say details.
    On the digest page, you can ask for the specific details: sender name, recipient name, sender address, recipient address, sender validated, recipient validated, logos, and links.
    On the email page, you can ask for the specific email details: subject, text, sender, and recipients.
    On the digest and recipients pages, say help to receive more details on these options.
    ''';

  String general = 
    '''
    At any time, to stop the current audio, say stop.
    To turn the speakers off, say speakers off.
    To turn the speakers on, say speakers on.
    To mute the microphone, say mute.
    To unmute the microphone, say unmute.
    To go back to the previous page, say back.
    To get the list of commands for the page that you are currently on, say help.
    ''';

  void runTutorial() async {
    if (!ranTutorial) {
      String readTutorial = '$tutorial $main $digest $email $digestAndEmail $general';
      await _speak(readTutorial);
      await _stop();
      ranTutorial = true;
    }
  }

  String mainHelp =
    '''
    To sign out of your account, say sign out.
    To navigate to the settings page, say settings.
    To navigate to the digest page, there are two voice command options.
    Option 1 is to get the latest mail, by saying latest digest.
    Option 2 is to get a digest for a specific date, by saying digest date followed by the date.
    To navigate to the email page, there are three voice command options.
    Option 1 is to get emails for a specific date, by saying email date followed by the date.
    Option 2 is to get the latest email, by saying latest email.
    Option 3 is to get emails you have no listened to yet, by saying unread email.
    To stop any current audio, say stop.
    To turn the speakers off, say speakers off.
    To turn the speakers on, say speakers on.
    To mute the microphone, say mute.
    To unmute the microphone, say unmute.
    To hear these commands again, say help.
    ''';

  String emailHelp =
    '''
    To go to the next email, say next.
    To go to the previous email, say previous.
    To get the details for the current email, say details.
    To get the current email subject, say subject.
    To get the current email text, say text.
    To get the current email sender, say sender.
    To get the current email recipients, say recipients.
    To go back to the main page, say back.
    To stop any current audio, say stop.
    To turn the speakers off, say speakers off.
    To turn the speakers on, say speakers on.
    To mute the microphone, say mute.
    To unmute the microphone, say unmute.
    To hear these commands again, say help.
    ''';

  String digestHelp =
    '''
    To go to the next digest, say next.
    To go to the previous digest, say previous.
    To get the details for the current digest, say details.
    To get sender's name for the current digest, say sender name.
    To get recipients's name for the current digest, say recipient name.
    To get sender's address for the current digest, say sender address.
    To get recipient's address for the current digest, say recipient address.
    To get if the sender's address for the current digest was validated, say sender validated.
    To get if the recipient's address for the current digest was validated, say recipient validated.
    To get the logos for the current digest, say logos.
    To get the links for the current digest, say links.
    To go back to the main page, say back.
    To stop any current audio, say stop.
    To turn the speakers off, say speakers off.
    To turn the speakers on, say speakers on.
    To mute the microphone, say mute.
    To unmute the microphone, say unmute.
    To hear these commands again, say help.
    ''';

  String settingsHelp =
    '''
    The following commands allow you to customize the details that you are told by default for digests and emails.
    To turn on the sender default, say sender on.
    To turn off the sender default, say sender off.
    To turn on the recipient default, say recipient on.
    To turn off the recipient default, say recipient off.
    To turn on the logos default, say logos on.
    To turn off the logos default, say logos off.
    To turn on the hyperlinks default, say hyperlinks on.
    To turn off the hyperlinks default, say hyperlinks off.
    To turn on the address default, say address on.
    To turn off the address default, say address off.
    To turn on the email subject default, say email subject on.
    To turn off the email subject default, say email subject off.
    To turn on the email text default, say email text on.
    To turn off the email text default, say email text off.
    To turn on the email sender address default, say email sender address on.
    To turn off the email sender address default, say email sender address off.
    To turn on the email recipients default, say email recipients on.
    To turn off the email recipients default, say email recipients off.
    To turn on autoplay so that the digests and emails are automatically played through, say autoplay on.
    To turn off autoplay so that you have to say next to navigate through the digests and emails, say autoplay off.
    To go back to the main page, say back.
    To stop any current audio, say stop.
    To turn the speakers off, say speakers off.
    To turn the speakers on, say speakers on.
    To mute the microphone, say mute.
    To unmute the microphone, say unmute.
    To hear these commands again, say help.
    ''';

    void getMainHelp() {
      _speak(mainHelp);
    }

    void getEmailHelp() {
      _speak(emailHelp);
    }

    void getDigestHelp() {
      _speak(digestHelp);
    }

    void getSettingsHelp() {
      _speak(settingsHelp);
    }
}
