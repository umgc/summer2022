import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:summer2022/Keychain.dart';
import 'package:summer2022/digest_email_parser.dart';
import 'package:summer2022/models/Arguments.dart';
import 'package:summer2022/models/Digest.dart';
import 'package:summer2022/models/EmailArguments.dart';
import 'package:summer2022/other_mail_parser.dart';
import 'package:summer2022/read_info.dart';
import 'package:summer2022/ui/mail_widget.dart';
import 'package:summer2022/ui/main_menu.dart';
import 'package:summer2022/main.dart';
import 'package:summer2022/ui/other_mail.dart';
import 'package:summer2022/ui/settings.dart';

class Speech {
  String currentPage = "settings";
  SpeechToText speech = SpeechToText();
  String words = '';
  String input = '';
  bool speechEnabled = false;
  bool mute = false;
  var formatter = DateFormat('yyy-MM-dd');
  dynamic username;
  dynamic password;
  Digest digest = Digest();
  CommandTutorial tutorial = CommandTutorial();
  late List<Digest> emails;
  late MailWidgetState _mailWidgetState;
  late OtherMailWidgetState _otherMailWidgetState;
  late MainWidgetState _mainWidgetState;
  bool links = false;

  void setCurrentPage(String page, [Object? obj]) {
    switch (page) {
      case 'mail':
        if (obj != null) {
          _mailWidgetState = obj as MailWidgetState;
        }
        break;
      case 'email':
        if (obj != null) {
          _otherMailWidgetState = obj as OtherMailWidgetState;
        }
        break;
      case 'main':
        if (obj != null) {
          _mainWidgetState = obj as MainWidgetState;
        }
        break;
      case 'settings':
        break;
      case 'login':
        break;
      default:
        break;
    }
    currentPage = page;
  }

  void setAccountInfo() async {
    username = await Keychain().getUsername();
    password = await Keychain().getPassword();
  }

  Future<List<Digest>> getEmail(bool unread) async {
    setAccountInfo();
    List<Digest> digest = await OtherMailParser().createEmailList(
        unread,
        await Keychain().getUsername(),
        await Keychain().getPassword(),
        DateTime.now());
    if (digest.isEmpty) {
      // If don't have one for today, try yesterday
      DateTime date = DateTime.now().subtract(const Duration(days: 1));
      digest = await OtherMailParser()
          .createEmailList(false, username, password, date);
    }
    return digest;
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
      if (input.isNotEmpty) {
        print(input);
        await command(input);
      }
      input = '';
      words = '';
      await Future.delayed(const Duration(seconds: 6));
    }
  }

  DateTime? processDate(String theDate) {
    // Expected input example: June 8th 2022

    // Validate input
    var months = {
      "January": "1", "February": "2", "March": "3", "April": "4",
      "May": "5", "June": "6", "July": "7", "August": "8",
      "September": "9", "October": "10", "November": "11", "December": "12"
    };
    bool foundMonth = false;
    for (var key in months.keys) {
      if (theDate.contains(key)) {
        foundMonth = true;
        String? val = months[key];
        if (val != null) {
          theDate = theDate.replaceFirst(key, val);
        }
        break;
      }
    }

    if (!foundMonth) {
      return null;
    }

    var numberSuffixes = {
      "1st": "1", "2nd": "2", "3rd": "3", "4th": "4", "5th": "5", "6th": "6", 
      "7th": "7", "8th": "8", "9th": "9", "10th": "10", "11th": "11",
      "12th": "12","13th": "13","14th": "14", "15th": "15", "16th": "16",
      "17th": "17", "18th": "18", "19th": "19", "20th": "20", "21st": "21",
      "22nd": "22", "23rd": "23", "24th": "24", "25th": "25", "26th": "26",
      "27th": "27", "28th": "28", "29th": "29", "30th": "30", "31st": "31"
    };
    for (var key in numberSuffixes.keys) {
      if (theDate.contains(key)) {
        String? val = numberSuffixes[key];
        if (val != null) {
          theDate = theDate.replaceFirst(key, val);
        }
      }
    }

    DateTime? dt;
    try {
      // Current format "6 8 2022"
      var splitDate = theDate.split(" ");
      // DateTime expects year, month, day
      dt = DateTime(int.parse(splitDate[2]), int.parse(splitDate[0]), int.parse(splitDate[1]));
    } catch(e) {
      print(e.toString());
      return null;
    }
    return dt;
  }

  // The commands that the user can utilise
  command(String s) async {
    //General commands
    if (s == 'unmute') {
      mute = false;
      return;
    }

    if (mute == false) {
      switch (currentPage) {
        case 'mail':
          switch (s.toLowerCase()) {
            // mail page commands
            case 'next':
              _mailWidgetState.setState(() {
                _mailWidgetState.seekForward(1);
              });
              break;
            case 'previous':
              _mailWidgetState.setState(() {
                _mailWidgetState.seekBack();
              });
              break;
            case 'details':
              _mailWidgetState.readMailPiece();
              break;
            case 'center name':
            case 'sender name':
            case 'send her name':
            case 'sonder name':
              try {
                _mailWidgetState.reader!.readDigestSenderName();
              } catch (e) {
                tts.speak('There is no sender name');
              }
              break;
            case 'recipient name':
              try {
                _mailWidgetState.reader!.readDigestRecipientName();
              } catch (e) {
                tts.speak('There is no recipient name');
              }
              break;
            case 'center address':
            case 'sender address':
            case 'send her address':
            case 'sonder address':
              try {
                _mailWidgetState.reader!.readDigestSenderAddress();
              } catch (e) {
                tts.speak('There is no sender address');
              }

              break;
            case 'recipient address':
              try {
                _mailWidgetState.reader!.readDigestRecipientAddress();
              } catch (e) {
                tts.speak('There is no recipient address');
              }

              break;
            case 'center validated':
            case 'sender validated':
            case 'send her validated':
            case 'sonder validated':
              try {
                _mailWidgetState.reader!.readDigestSenderAddressValidated();
              } catch (e) {
                tts.speak('There is no sender validation');
              }
              break;
            case 'recipient validated':
              try {
                _mailWidgetState.reader!.readDigestRecipientAddressValidated();
              } catch (e) {
                tts.speak('There is no recipient validation');
              }
              break;
            case 'logos':
              try {
                _mailWidgetState.reader!.readDigestLogos();
              } catch (e) {
                tts.speak('There are no logos');
              }
              break;
            case 'help':
              tutorial.getDigestHelp();
              break;
            case 'back':
              navKey.currentState!.pushNamed('/main');
              break;
            default:
              if (s.contains("hyperlink")) {
                if (s == 'hyperlinks' && links == false) {
                  _mailWidgetState.reader!.readDigestLinks();
                  _mailWidgetState.showLinkDialog();
                  links = true;
                }
                if (s == 'close hyperlinks' && links == true) {
                  navKey.currentState!.pop();
                  links = false;
                } else {
                  try {
                    var position = s.split(" ")[0];
                    if (position == 'first' || position == '1st') {
                      try {
                        _mailWidgetState
                            .openLink(_mailWidgetState.links[0].link);
                      } catch (e) {
                        tts.speak(
                            'There is not a valid hyperlink in the first position');
                      }
                    }
                    if (position == 'second' || position == '2nd') {
                      try {
                        _mailWidgetState
                            .openLink(_mailWidgetState.links[1].link);
                      } catch (e) {
                        tts.speak(
                            'There is not a valid hyperlink in the second position');
                      }
                    }
                    if (position == 'third' || position == '3rd') {
                      try {
                        _mailWidgetState
                            .openLink(_mailWidgetState.links[2].link);
                      } catch (e) {
                        tts.speak(
                            'There is not a valid hyperlink in the third position');
                      }
                    }
                    if (position == 'fourth' || position == '4th') {
                      try {
                        _mailWidgetState
                            .openLink(_mailWidgetState.links[3].link);
                      } catch (e) {
                        tts.speak(
                            'There is not a valid hyperlink in the fourth position');
                      }
                    }
                    if (position == 'fifth' || position == '5th') {
                      try {
                        _mailWidgetState
                            .openLink(_mailWidgetState.links[4].link);
                      } catch (e) {
                        tts.speak(
                            'There is not a valid hyperlink in the fifth position');
                      }
                    }
                  } catch (e) {
                    break;
                  }
                }
              }
              break;
          }
          break;
        case 'email':
          switch (s) {
            // mail page commands
            case 'next':
              _otherMailWidgetState.setState(() {
                _otherMailWidgetState.seekForward();
              });
              break;
            case 'previous':
              _otherMailWidgetState.setState(() {
                _otherMailWidgetState.seekBack();
              });
              break;
            case 'details':
              _otherMailWidgetState.reader!.readEmailInfo();
              break;
            case 'subject':
              _otherMailWidgetState.reader!.readEmailSubject();
              break;
            case 'text':
              _otherMailWidgetState.reader!.readEmailText();
              break;
            case 'center':
            case 'sender':
            case 'send her':
            case 'sonder':
              _otherMailWidgetState.reader!.readEmailSender();
              break;
            case 'recipients':
              _otherMailWidgetState.reader!.readEmailRecipients();
              break;
            case 'help':
              tutorial.getEmailHelp();
              break;
            case 'back':
              navKey.currentState!.pushNamed('/main');
              break;
            default:
              break;
          }
          break;
        // Main menu commands
        case 'main':
          switch (s.toLowerCase()) {
            case "unread email":
              List<Digest> digest = await getEmail(true);
              navKey.currentState!.pushNamed('/other_mail',
                  arguments: EmailWidgetArguments(digest));
              break;
            case 'latest email':
              List<Digest> digest = await getEmail(false);
              navKey.currentState!.pushNamed('/other_mail',
                  arguments: EmailWidgetArguments(digest));
              break;
            case 'latest digest':
              try {
                digest = await DigestEmailParser().createDigest(
                    await Keychain().getUsername(),
                    await Keychain().getPassword());
                if (!digest.isNull()) {
                  navKey.currentState!.pushNamed('/digest_mail',
                      arguments: MailWidgetArguments(digest));
                } else {
                  tts.speak('There are no digests available for today');
                }
              } catch (e) {
                tts.speak(
                    'An error occurred while fetching your daily digest: $e');
              }
              break;
            case 'settings':
              navKey.currentState!.pushNamed('/settings');
              break;
            case 'sign out':
              navKey.currentState!.pushNamed('/sign_in');
              break;
            case 'tutorial off':
              cfg.updateValue("tutorial", false);
              break;
            case 'help':
              tutorial.getMainHelp();
              break;
            default:
              // User asks for emails from specific date
              if (s.contains("email date")) {
                String requestedDate = s.split("date ")[1];
                DateTime? dt = processDate(requestedDate);
                if (dt != null) {
                  try {
                    emails = await OtherMailParser().createEmailList(
                        false,
                        await Keychain().getUsername(),
                        await Keychain().getPassword(),
                        dt);
                    if (emails.isNotEmpty) {
                      navKey.currentState!.pushNamed('/other_mail',
                          arguments: EmailWidgetArguments(emails));
                    } else {
                      tts.speak(
                          'There are no digest available for $requestedDate');
                    }
                  } catch (e) {
                    tts.speak(
                        'An error occurred while fetching your emails: $e');
                  }
                } else {
                  tts.speak(
                      'The specified date is invalid. Please say the month, day of the month, and then the year.');
                }
              }
              // User asks for digest from specific date
              if (s.contains("digest date")) {
                String requestedDate = s.split("date ")[1];
                DateTime? dt = processDate(requestedDate);
                if (dt != null) {
                  try {
                    digest = await DigestEmailParser().createDigest(
                        await Keychain().getUsername(),
                        await Keychain().getPassword(),
                        dt);
                    if (!digest.isNull()) {
                      navKey.currentState!.pushNamed('/digest_mail',
                          arguments: MailWidgetArguments(digest));
                    } else {
                      tts.speak(
                          'There are no digest available for $requestedDate');
                    }
                  } catch (e) {
                    tts.speak(
                        'An error occurred while fetching your daily digest: $e');
                  }
                } else {
                  tts.speak(
                      'The specified date is invalid. Please say the month, day of the month, and then the year.');
                }
              }
              break;
          }
          break;
        // settings page commands
        case 'settings':
          switch (s.toLowerCase()) {
            case 'center on':
            case 'sender on':
            case 'send her on':
            case 'sonder on':
              cfg.updateValue("sender", true);
              break;
            case 'center off':
            case 'sender off':
            case 'send her off':
            case 'sonder off':
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
              cfg.updateValue("autoplay", true);
              break;
            case 'autoplay off':
              cfg.updateValue("autoplay", false);
              break;
            case 'tutorial on':
              cfg.updateValue("tutorial", true);
              break;
            case 'tutorial off':
              cfg.updateValue("tutorial", false);
              break;
            case 'help':
              tutorial.getSettingsHelp();
              break;
            case 'back':
              navKey.currentState!.pushNamed('/main');
              break;
            default:
              break;
          }
          break;
      }
      // General commands
      switch (s) {
        case 'mute':
          mute = true;
          break;
        case 'stop':
          tts.stop();
          break;
        case 'speakers off':
          tts.stop();
          tts.setVolume(0);
          break;
        case 'speakers on':
          tts.stop();
          tts.setVolume(1);
          break;
        default: // Invalid command
          break;
      }
    }
  }
}
