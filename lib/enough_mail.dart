import 'package:enough_mail/enough_mail.dart';

// Add your credentials
String userName = ''; // Add your credentials
String password = ''; // Add your credentials
String imapServerHost = 'imap.gmail.com';
int imapServerPort = 993;
bool isImapServerSecure = true;
String popServerHost = 'pop.gmail.com';
int popServerPort = 995;
bool isPopServerSecure = true;
String smtpServerHost = 'smtp.google.com';
int smtpServerPort = 465;
bool isSmtpServerSecure = true;

// void main() async {
//   await discoverExample();
//   await imapExample();
//   //await smtpExample();
//   //await popExample();
//   exit(0);
// }

Future<void> discoverExample() async {
  var email = 'razielxp4@yahoo.com';
  var config = await Discover.discover(email, isLogEnabled: false);
  if (config == null) {
    print('Unable to discover settings for $email');
  } else {
    print('Settings for $email:');
    for (var provider in config.emailProviders!) {
      print('provider: ${provider.displayName}');
      print('provider-domains: ${provider.domains}');
      print('documentation-url: ${provider.documentationUrl}');
      print('Incoming:');
      print(provider.preferredIncomingServer);
      print('Outgoing:');
      print(provider.preferredOutgoingServer);
    }
  }
}

/// Low level IMAP API usage example
Future<List<MimeMessage>> imapExample() async {
  final client = ImapClient(isLogEnabled: true);

  try {
    await client.connectToServer(imapServerHost, imapServerPort,
        isSecure: isImapServerSecure);
    await client.login(userName, password);
    final mailboxes = await client.listMailboxes();
    //print('mailboxes: $mailboxes');
    await client.selectInbox();
    // fetch 10 most recent messages:
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 10, criteria: 'BODY.PEEK[]');
    for (final message in fetchResult.messages) {
      print("---------------------------------------------------------------");

      print("To: ${message.to}");
      print("From: ${message.from}");
      print("Date: ${message.decodeDate()}");
      print("Subject: ${message.decodeSubject()}");
      print("Body:${message.decodeTextPlainPart()}");

      // printMessage(message);
      print("---------------------------------------------------------------");
    }
    print("---------------------------------------------------------------");
    print("Done");
    print("---------------------------------------------------------------");

    await client.logout();
    return fetchResult.messages;
  } on ImapException catch (e) {
    print('IMAP failed with $e');
  }
  return [];
}

/// Low level SMTP API example
Future<void> smtpExample() async {
  final client = SmtpClient('enough.de', isLogEnabled: true);
  try {
    await client.connectToServer(smtpServerHost, smtpServerPort,
        isSecure: isSmtpServerSecure);
    await client.ehlo();
    if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
      await client.authenticate('user.name', 'password', AuthMechanism.plain);
    } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
      await client.authenticate('user.name', 'password', AuthMechanism.login);
    } else {
      return;
    }
    final builder = MessageBuilder.prepareMultipartAlternativeMessage(
      plainText: 'hello world.',
      htmlText: '<p>hello <b>world</b></p>',
    )
      ..from = [MailAddress('My name', 'sender@domain.com')]
      ..to = [MailAddress('Your name', 'recipient@domain.com')]
      ..subject = 'My first message';
    final mimeMessage = builder.buildMimeMessage();
    final sendResponse = await client.sendMessage(mimeMessage);
    print('message sent: ${sendResponse.isOkStatus}');
  } on SmtpException catch (e) {
    print('SMTP failed with $e');
  }
}

/// Low level POP3 API example
Future<void> popExample() async {
  final client = PopClient(isLogEnabled: false);
  try {
    await client.connectToServer(popServerHost, popServerPort,
        isSecure: isPopServerSecure);
    await client.login(userName, password);
    // alternative login:
    // await client.loginWithApop(userName, password); // optional different login mechanism
    final status = await client.status();
    print(
        'status: messages count=${status.numberOfMessages}, messages size=${status.totalSizeInBytes}');
    final messageList = await client.list(status.numberOfMessages);
    print(
        'last message: id=${messageList.first.id} size=${messageList.first.sizeInBytes}');
    var message = await client.retrieve(status.numberOfMessages);
    printMessage(message);
    message = await client.retrieve(status.numberOfMessages + 1);
    print('trying to retrieve newer message succeeded');
    await client.quit();
  } on PopException catch (e) {
    print('POP failed with $e');
  }
}

void printMessage(MimeMessage message) {
  print('from: ${message.from} with subject "${message.decodeSubject()}"');
  if (!message.isTextPlainMessage()) {
    print(' content-type: ${message.mediaType}');
  } else {
    final plainText = message.decodeTextPlainPart();
    if (plainText != null) {
      final lines = plainText.split('\r\n');
      for (final line in lines) {
        if (line.startsWith('>')) {
          // break when quoted text starts
          break;
        }
        print(line);
      }
    }
  }
}
