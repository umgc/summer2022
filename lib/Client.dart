import 'dart:io';
import 'package:enough_mail/enough_mail.dart';
import 'Keychain.dart';

class Client {
  Client();

  Future<void> imapExample(String username, String password) async {
    final client = ImapClient(isLogEnabled: false);
    var config = await Discover.discover(username, isLogEnabled: false);
    if (config == null) {
      // print('Unable to discover settings for $email');
    } else {
      // print('Settings for $email:');
      var imapServerConfig = config.preferredIncomingImapServer;
      try {
        await client.connectToServer(
            imapServerConfig!.hostname as String, imapServerConfig.port as int,
            isSecure: imapServerConfig.isSecureSocket);
        await client.login(username, password);
        await client.connectToServer(
            imapServerConfig!.hostname as String, imapServerConfig.port as int,
            isSecure: imapServerConfig.isSecureSocket);
        await client.login(username, password);
        final mailboxes = await client.listMailboxes();
        print('mailboxes: $mailboxes');
        await client.selectInbox();
        // fetch 10 most recent messages:
        final fetchResult = await client.fetchRecentMessages(
            messageCount: 10, criteria: 'BODY.PEEK[]');
        for (final message in fetchResult.messages) {
          printMessage(message);
        }
        await client.logout();
      } on ImapException catch (e) {
        print('IMAP failed with $e');
      }
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

  Future<bool> getImapClient(String username, String password) async {
    final client = ImapClient(isLogEnabled: false);
    var config = await Discover.discover(username, isLogEnabled: false);
    if (config == null) {
      // print('Unable to discover settings for $email');
      return false;
    } else {
      // print('Settings for $email:');
      var imapServerConfig = config.preferredIncomingImapServer;
      try {
        await client.connectToServer(
            imapServerConfig!.hostname as String, imapServerConfig.port as int,
            isSecure: imapServerConfig.isSecureSocket);
        await client.login(username, password);
        var loggedIn = client.isLoggedIn;
        await client.logout();
        return loggedIn;
      } on ImapException catch (e) {
        print('IMAP failed with $e');
        return false;
      }
    }
  }

/* Derived from enough_mail*/
  Future<ServerConfig?> getServerConfigFromEmail(String email) async {
    var config = await Discover.discover(email, isLogEnabled: false);
    if (config == null) {
      // print('Unable to discover settings for $email');
      return null;
    } else {
      // print('Settings for $email:');
      for (var provider in config.emailProviders!) {
        print(provider.preferredIncomingServer);
        return provider.preferredIncomingServer;
      }
    }
  }
}
