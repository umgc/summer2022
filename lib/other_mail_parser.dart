import 'package:enough_mail/enough_mail.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
import 'image_processing/google_cloud_vision_api.dart';
import 'models/Digest.dart';

class OtherMailParser {
  String _userName = ''; // Add your credentials
  String _password = ''; // Add your credentials
  String _imapServerHost = 'imap.gmail.com';
  int _imapServerPort = 993;
  bool _isImapServerSecure = true;
  DateTime? _targetDate;
  bool _isUnread = false;
  final int maxUnreadEmails = 30;

  Future<List<Digest>> createEmailList(
      bool isUnread, String userName, String password,
      [DateTime? targetDate]) async {
    this._userName = userName;
    this._password = password;
    this._targetDate = targetDate;
    this._isUnread = isUnread;

    // NOTE: this looks like a casting to type digest will need occur within getEmails()
    //Digest digest = Digest(await _getEmails());
    List<Digest> emails = await _getEmails();

    return emails;
  }

  String _formatTargetDateForSearch(DateTime date) {
    final DateFormat format = DateFormat('dd-MMM-yyyy');
    return format.format(date);
  }

  Future<List<Digest>> _getEmails() async {
    final client = ImapClient(isLogEnabled: true);
    try {
      DateTime targetDate = _targetDate ?? DateTime.now();
      String searchCriteria = 'ON ${_formatTargetDateForSearch(targetDate)}';
      if (_isUnread) {
        searchCriteria = 'UNSEEN';
      }

      var config = await Discover.discover(_userName, isLogEnabled: false);
      var imapServerConfig = config?.preferredIncomingImapServer;
      await client.connectToServer(
          imapServerConfig!.hostname as String, imapServerConfig.port as int,
          isSecure: imapServerConfig.isSecureSocket);
      // await client.connectToServer(_imapServerHost, _imapServerPort,
      // isSecure: _isImapServerSecure);
      await client.login(_userName, _password);
      await client.selectInbox();

      List<ReturnOption> returnOptions = [];
      ReturnOption option = ReturnOption("all");
      returnOptions.add(option);
      final searchResult = await client.searchMessages(
          searchCriteria: searchCriteria, returnOptions: returnOptions);
      final matchingSequence = searchResult.matchingSequence;

      List<Digest> emails = [];
      List<int> seqIdList = [];
      String seqIdStr = "";
      Iterator<int>? seqIdsIter = matchingSequence?.every().iterator;
      if (seqIdsIter != null) {
        // populate sequence Ids list
        while (seqIdsIter.moveNext()) {
          seqIdList.add(seqIdsIter.current);
        }

        // pull largest seq numbers first with maxUnreadEmail limit
        int emailCount = 0;
        int seqListLength = seqIdList.length;
        if (seqListLength != 0) {
          seqIdStr = seqIdList[seqListLength - 1].toString();
        }
        for (int i = seqListLength - 2;
            i > 0 && emailCount < maxUnreadEmails - 1;
            i--) {
          seqIdStr += "," + seqIdList[i].toString();
          emailCount++;
        }

        // fetch all emails from seqIds returned from search
        print('?: searchCriteria: ' + seqIdStr);
        if (emailCount != 0) {
          // Search Criteria sequence ids can be entered '1:20' or '1,2,6,9,...'
          final fetchedMessage =
              await client.fetchMessagesByCriteria(seqIdStr + ' (BODY.PEEK[])');
          fetchedMessage.messages.forEach((message) {
            emails.add(Digest(message));
          });
        } else {
          print("?:  No sequence Ids");
        }
      }

      return emails;
    } catch (e) {
      rethrow;
    } finally {
      if (client.isLoggedIn) {
        await client.logout();
      }
    }
  }

  String _formatDateTime(DateTime? date) {
    if (date != null) {
      return "${date.year}-${date.month}-${date.day}";
    } else {
      return "";
    }
  }
}
