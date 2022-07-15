import 'package:enough_mail/enough_mail.dart';
import 'package:summer2022/models/MailResponse.dart';

class Digest {
  MimeMessage message = MimeMessage();
  List<Attachment> attachments = [];
  List<Link> links = [];

  Digest(MimeMessage m) {
    message = m;
  }
}

class Attachment {
  String attachment = "";
  String attachmentNoFormatting = "";
  late MailResponse detailedInformation;
}

class Link {
  String link = "";
  String info = "";
}