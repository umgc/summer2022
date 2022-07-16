import 'package:enough_mail/enough_mail.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'models/Digest.dart';

class DigestEmailParser {

  String _userName = ''; // Add your credentials
  String _password = ''; // Add your credentials
  String _imapServerHost = 'imap.gmail.com';
  int _imapServerPort = 993;
  bool _isImapServerSecure = true;
  DateTime? _targetDate;

  Future<Digest> createDigest(String userName, String password, [DateTime? targetDate]) async {
    this._userName = userName;
    this._password = password;
    this._targetDate = targetDate;
    Digest digest = Digest(await _getDigestEmail());
    digest.attachments = await _getAttachments(digest.message);
    digest.links = _getLinks(digest.message);
    return digest;
  }

  Future<List<Attachment>> _getAttachments(MimeMessage m) async {
    List<Attachment> list = [];
    m.mimeData?.parts?.forEach((item) async {
      if(item.contentType?.value.toString().contains("image") ?? false) {
        var attachment = Attachment();
        attachment.attachment = item.decodeMessageData().toString(); //These are base64 encoded images with formatting
        attachment.attachmentNoFormatting = attachment.attachment.toString().replaceAll("\r\n", ""); //These are base64 encoded images with formatting
        //attachment.detailedInformation = await CloudVisionApi().search(attachment.attachment); //TODO get CloudVisionAPI info
        list.add(attachment);
      }
    });
    return list;
  }

  List<Link> _getLinks(MimeMessage m){
    List<Link> list = [];
    RegExp linkExp = RegExp(r"(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])");
    String text = m.decodeTextPlainPart() ?? ""; //get body text of email
    //remove encoding to make text easier to interpret
    text = text.replaceAll('\r\n', " ");
    text = text.replaceAll('<', " ");
    text = text.replaceAll('>', " ");
    text = text.replaceAll(']', " ");
    text = text.replaceAll('[', " ");

    while(linkExp.hasMatch(text)) {
      var match = linkExp.firstMatch(text)?.group(0);
      Link link = Link();
      link.link = match.toString();
      link.info = text.split(match.toString())[0].toString().split('.').last.toString().trim(); //attempt to get information about the link
      list.add(link);
      text = text.substring(text.indexOf(match.toString()) + match.toString().length); //remove the found link and continue searching
    }
    return list;
  }

  String _formatTargetDateForSearch(DateTime date) {
    final DateFormat format = DateFormat('dd-MMM-yyyy');
    return format.format(date);
  }

  Future<MimeMessage> _getDigestEmail() async {
    final client = ImapClient(isLogEnabled: true);
    try {
      DateTime targetDate = _targetDate ?? DateTime.now();
      await client.connectToServer(_imapServerHost, _imapServerPort,
          isSecure: _isImapServerSecure);
      await client.login(_userName, _password);
      await client.selectInbox();
      //Search for sequence id of the Email
      String searchCriteria = 'FROM USPSInformeddelivery@email.informeddelivery.usps.com ON ${_formatTargetDateForSearch(targetDate)} SUBJECT "Your Daily Digest"';
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
      if(seqID != null) {
        //Fetch Email Results
        final fetchedMessage = await client.fetchMessage(seqID, 'BODY.PEEK[]');
        return fetchedMessage.messages.first;
      }

      return MimeMessage();
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