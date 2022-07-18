import 'package:enough_mail/enough_mail.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'models/Digest.dart';

class OtherMailParser {

  String _userName = ''; // Add your credentials
  String _password = ''; // Add your credentials
  String _imapServerHost = 'imap.gmail.com';
  int _imapServerPort = 993;
  bool _isImapServerSecure = true;
  DateTime? _targetDate;

  Future<List<Digest>> createEmailList(String userName, String password, [DateTime? targetDate]) async {
    this._userName = userName;
    this._password = password;
    this._targetDate = targetDate;

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
      await client.connectToServer(_imapServerHost, _imapServerPort,
          isSecure: _isImapServerSecure);
      await client.login(_userName, _password);
      await client.selectInbox();
      //Search for sequence id of the Email
      String searchCriteria = 'ON ${_formatTargetDateForSearch(targetDate)}';
      List<ReturnOption> returnOptions = [];
      ReturnOption option = ReturnOption("all");
      returnOptions.add(option);
      final searchResult = await client.searchMessages(searchCriteria: searchCriteria, returnOptions: returnOptions);
      //extract sequence id
      int? seqID;
      final matchingSequence = searchResult.matchingSequence;
      if(matchingSequence != null ) {
        seqID = matchingSequence.isNotEmpty ? matchingSequence.elementAt(0) : null; // this gets the sequence id of the desired email
      }

      print('!!!!!!!!!!!!!!');
      print('count: ');
      print(searchResult.count);
      print('matchingSequence');
      print(matchingSequence?.length.toString());
      print('matchingSequence');
      print(matchingSequence?.every());
      Iterator<int>? seqIdsIter = matchingSequence?.every().iterator;
      print('matchingSequence.every.length: ');
      print(matchingSequence?.every().length.toString());

      List<Digest> emails = [];
      if (seqIdsIter != null)
      {
        while (seqIdsIter.moveNext())
        {
          final fetchedMessage = await client.fetchMessage(seqIdsIter.current, 'BODY.PEEK[]');
          emails.add(Digest(fetchedMessage.messages.first));
          //seqIdsIter.current
        }
      }

      return emails;
    } catch (e) {
      rethrow;
    }
    finally {
      if(client.isLoggedIn) {
        await client.logout();
      }
    }
  }

  String _formatDateTime(DateTime? date) {
    if (date != null) {
      return "${date.year}-${date.month}-${date.day}";
    }
    else{
      return "";
    }
  }
}