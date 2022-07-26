import 'package:enough_mail/pop.dart';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/Logo.dart';
import 'package:summer2022/models/Digest.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

Future<bool> _speak(String text) async {
  if (text.isNotEmpty) {
    var result = await tts.awaitSpeakCompletion(true);
    var read = await tts.speak(text);
  }
  return true;
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
  Future<bool> readDigestInfo() async {
    if (GlobalConfiguration().getValue("sender") == true && sender != null) {
      var read = await readDigestSenderName();
    }
    if (GlobalConfiguration().getValue("recipient") == true && recipient != null) {
      var read = await readDigestRecipientName();
    }
    if (GlobalConfiguration().getValue("validated") == true) {
      if(sender != null) {
        var read = await readDigestSenderAddressValidated();
      }
      if(recipient != null) {
        var read = await readDigestRecipientAddressValidated();
      }
    }
    if (GlobalConfiguration().getValue("address") == true) {
      if(sender != null) {
        var read = await readDigestSenderAddress();
      }
      if(recipient != null) {
        var read = await readDigestRecipientAddress();
      }
    }
    if (GlobalConfiguration().getValue("logos") == true) {
      var read = await readDigestLogos();
    }
    if (GlobalConfiguration().getValue("links") == true) {
      var read = await readDigestLinks();
    }
    return true;
  }

  Future<bool> readDigestSenderName() async {
    /* Get the name of the sender */
    String text = "The sender is '${sender!.name}'";
    var read = await _speak(text);
    return true;
  }

  Future<bool> readDigestRecipientName() async {
    /* Get the name of the recipient */
    String text = "The recipient is '${recipient!.name}'";
    var read = await _speak(text);
    return true;
  }

  Future<bool> readDigestSenderAddress() async {
    /* Get the sender's address */
    String text = "The sender's address is '${sender!.address}'";
    var read = await _speak(text);
    return true;
  }

  Future<bool> readDigestRecipientAddress() async {
    /* Get the recipient's address */
    String text = "The recipient's address is '${recipient!.address}'";
    var read = await _speak(text);
    return true;
  }

  Future<bool> readDigestLogos() async {
    /* Get the logos */
    for (LogoObject logo in currentMail.logos) {
      String text = "The logo says '${logo.name}'";
      var read = await _speak(text);
    }
    return true;
  }

  Future<bool> readDigestLinks() async {
    /* Get the links */
    for (Link code in links) {
      String text = "The link is '${code.link}'. Would you like to go to the link?";
      var read = await _speak(text);
    }
    return true;
  }

  Future<bool> readDigestSenderAddressValidated() async {
    /* Get if the sender's address was validated */
    String validated = "was not";

    if (sender!.validated) {
      validated = "was";
    }
    String text = "The sender's address $validated validated";
    var read = await _speak(text);
    return true;
  }

  Future<bool> readDigestRecipientAddressValidated() async {
    /* Get if the recipient's address was validated */
    String validated = "was not";
    if (recipient!.validated) {
      validated = "was";
    }
    String text = "The recipient's address $validated validated";
    var read = await _speak(text);
    return true;
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
  Future<bool> readEmailInfo() async {
    if (GlobalConfiguration().getValue("email_subject") == true) {
      var read = await readEmailSubject();
    }
    if (GlobalConfiguration().getValue("email_text") == true) {
      var read = await readEmailText();
    }
    if (GlobalConfiguration().getValue("email_sender") == true) {
      var read = await readEmailSender();
    }
    if (GlobalConfiguration().getValue("email_recipients") == true) {
      var read = await readEmailRecipients();
    }
    return true;
  }

  Future<bool> readEmailSubject() async {
    var subject = currentMail.decodeSubject();
    String text = "The email subject is $subject";
    if (subject != null) {
      var read = await _speak(text);
    } else {
      var read = await _speak("There is no email subject.");
    }
    return true;
  }

  Future<bool> readEmailText() async {
    var emailText = currentMail.body;
    String text = "The email text is $emailText";
    if (emailText != null) {
      var read = await _speak(text);
    } else {
      var read = await _speak("There is no email text.");
    }
    return true;
  }

  Future<bool> readEmailSender() async {
    var sender = currentMail.decodeSender();
    String text = "The email sender is $sender";
    if (sender != null) {
      var read = await _speak(text);
    } else {
      var read = await _speak("There is no email sender.");
    }
    return true;
  }

  Future<bool> readEmailRecipients() async {
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
      var read = await _speak(text);
    } else {
      var read = await _speak("There are no email recipients.");
    }
    return true;
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

  Future<bool> runTutorial() async {
    if (!ranTutorial) {
      String readTutorial = '$tutorial $main $digest $email $digestAndEmail $general';
      var read = await _speak(readTutorial);
      await _stop();
      ranTutorial = true;
    }
    return true;
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

    Future<bool> getMainHelp() async {
      var read = await _speak(mainHelp);
      return true;
    }

    Future<bool> getEmailHelp() async {
      var read = await _speak(emailHelp);
      return true;
    }

    Future<bool> getDigestHelp() async {
      var read = await _speak(digestHelp);
      return true;
    }

    Future<bool> getSettingsHelp() async {
      var read = await _speak(settingsHelp);
      return true;
    }
}
