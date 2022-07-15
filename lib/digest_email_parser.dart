import 'package:enough_mail/enough_mail.dart';
import 'package:googleapis/cloudsearch/v1.dart';

class DigestEmailParser {

  String userName = 'GartrellBarry@gmail.com'; // Add your credentials
  String password = 'jcgbbrahopwwffma'; // Add your credentials
  String imapServerHost = 'imap.gmail.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;

  Future<List<MimeMessage>> getDigestEmails([DateTime? date]) async {
    final client = ImapClient(isLogEnabled: true);

    try {
      DateTime targetDate = date ?? DateTime.now();
      await client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await client.login(userName, password);
      final mailboxes = await client.listMailboxes();
      //print('mailboxes: $mailboxes');
      await client.selectInbox();
      // fetch 10 most recent messages:
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 50, criteria: 'BODY.PEEK[]');
      List<MimeMessage> list = <MimeMessage>[];
      for (final message in fetchResult.messages) {
        if((message.decodeSubject()?.contains("Your Daily Digest") ?? false) && message.decodeDate() == targetDate)
        {
          print("---------------------------------------------------------------");

          print("To: ${message.to}");
          print("From: ${message.from}");
          print("Date: ${message.decodeDate()}");
          print("Subject: ${message.decodeSubject()}");
          print("Body:${message.decodeTextPlainPart()}");

          // printMessage(message);
          print("---------------------------------------------------------------");
          list.add(message);
        }
      }
      print("---------------------------------------------------------------");
      print("Done");
      print("---------------------------------------------------------------");

      await client.logout();
      return list;
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
    return [];
  }
}