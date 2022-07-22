import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:enough_mail/enough_mail.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'image_processing/google_cloud_vision_api.dart';
import './models/Digest.dart';
import './models/Code.dart';
import './models/Logo.dart';
import 'image_processing/barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import './image_processing/usps_address_verification.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DigestEmailParser {
  String _userName = ''; // Add your credentials
  String _password = ''; // Add your credentials
  DateTime? _targetDate;
  CloudVisionApi vision = CloudVisionApi();
  BarcodeScannerApi? _barcodeScannerApi;
  String filePath = '';
  String imagePath =
      '/storage/emulated/0/Android/data/com.example.summer2022/files';

  Future<Digest> createDigest(String userName, String password,
      [DateTime? targetDate]) async {
    this._userName = userName;
    this._password = password;
    this._targetDate = targetDate;
    Digest digest = Digest(await _getDigestEmail());
    if (!digest.isNull()) {
      digest.attachments = await _getAttachments(digest.message);
      digest.links = _getLinks(digest.message);
    }

    return digest;
  }

  Future<List<Attachment>> _getAttachments(MimeMessage m) async {
    List<Attachment> list = [];
    await deleteImageFiles();
    for (int x = 0; x < m.mimeData!.parts!.length; x++) {
      if (m.mimeData!.parts!
              .elementAt(x)
              .contentType
              ?.value
              .toString()
              .contains("image") ??
          false) {
        var attachment = Attachment();
        attachment.attachment = m.mimeData!.parts!
            .elementAt(x)
            .decodeMessageData()
            .toString(); //These are base64 encoded images with formatting
        attachment.attachmentNoFormatting = attachment.attachment
            .toString()
            .replaceAll(
                "\r\n", ""); //These are base64 encoded images with formatting
        await saveImageFile(base64Decode(attachment.attachmentNoFormatting),
            "mailpiece" + x.toString() + ".jpg");
        attachment.detailedInformation = await processImage(filePath);
        list.add(attachment);
      }
    }
    return list;
  }

  List<Link> _getLinks(MimeMessage m) {
    List<Link> list = [];
    RegExp linkExp = RegExp(
        r"(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])");
    String text = m.decodeTextPlainPart() ?? ""; //get body text of email
    //remove encoding to make text easier to interpret
    text = text.replaceAll('\r\n', " ");
    text = text.replaceAll('<', " ");
    text = text.replaceAll('>', " ");
    text = text.replaceAll(']', " ");
    text = text.replaceAll('[', " ");

    while (linkExp.hasMatch(text)) {
      var match = linkExp.firstMatch(text)?.group(0);
      Link link = Link();
      link.link = match.toString();
      link.info = text
          .split(match.toString())[0]
          .toString()
          .split('.')
          .last
          .toString()
          .trim(); //attempt to get information about the link
      list.add(link);
      text = text.substring(text.indexOf(match.toString()) +
          match
              .toString()
              .length); //remove the found link and continue searching
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
      //Retrieve the imap server config
      var config = await Discover.discover(_userName, isLogEnabled: false);
      if (config == null) {
        return MimeMessage();
      } else {
        var imapServerConfig = config.preferredIncomingImapServer;
        await client.connectToServer(
            imapServerConfig!.hostname as String, imapServerConfig.port as int,
            isSecure: imapServerConfig.isSecureSocket);
        await client.login(_userName, _password);
        await client.selectInbox();
        //Search for sequence id of the Email
        String searchCriteria =
            'FROM USPSInformeddelivery@email.informeddelivery.usps.com ON ${_formatTargetDateForSearch(targetDate)} SUBJECT "Your Daily Digest"';
        List<ReturnOption> returnOptions = [];
        ReturnOption option = ReturnOption("all");
        returnOptions.add(option);
        final searchResult = await client.searchMessages(
            searchCriteria: searchCriteria, returnOptions: returnOptions);
        //extract sequence id
        int? seqID;
        final matchingSequence = searchResult.matchingSequence;
        if (matchingSequence != null) {
          seqID = matchingSequence.isNotEmpty
              ? matchingSequence.elementAt(0)
              : null; // this gets the sequence id of the desired email
        }
        if (seqID != null) {
          //Fetch Email Results
          final fetchedMessage =
              await client.fetchMessage(seqID, 'BODY.PEEK[]');
          return fetchedMessage.messages.first;
        }
        return MimeMessage();
      }
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

  deleteImageFiles() async {
    Directory? directory = await getExternalStorageDirectory();
    Directory? directory2 = await getTemporaryDirectory();
    var files = directory?.listSync(recursive: false, followLinks: false);
    var files2 = directory2.listSync(recursive: false, followLinks: false);
    for (int x = 0; x < files!.length; x++) {
      print("Delete in Extern: " + files[x].path);
      files[x].delete();
    }
    for (int x = 0; x < files2.length; x++) {
      print("Delete: " + files2[x].path);
      files[x].delete();
    }
  }

  void _processImageForLogo(String imagePath) async {
    print("Inside processImageForLogo\n");
    var image = File(imagePath);
    var buffer = image.readAsBytesSync();
    var a = base64.encode(buffer);
    List<LogoObject> logos = await vision.searchImageForLogo(a);
    var output = '';
    for (var logo in logos) {
      output += logo.toJson().toString() + "\n";
    }
    print(output);
    print("Exit ProcessImageForLogo");
  }

  void _processBarcode() async {
    print("Inside process barcode\n");
    _barcodeScannerApi = BarcodeScannerApi();
    var fLoc = filePath;
    print(fLoc);
    File? img = await _barcodeScannerApi?.getImageFileFromAssets(filePath);

    _barcodeScannerApi!.setImageFromFile(img!);

    List<CodeObject> codes = await _barcodeScannerApi!.processImage();
    var output = '';
    for (var code in codes) {
      output += code.toJson().toString();
    }
    print(output);
    print("Exit ProcessBarcode");
  }

  Future<bool> saveImageFile(Uint8List imageBytes, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          imagePath = directory!.path.toString();
          print(directory.path);
        } else {
          if (await _requestPermission(Permission.photos)) {
            directory = await getTemporaryDirectory();
            imagePath = directory.path;
            print(directory.path);
          } else {
            return false;
          }
        }
      }
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        saveFile.writeAsBytesSync(imageBytes);

        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        filePath = saveFile.path;
        print("Directory" + directory.listSync().toString());
        return true;
      }
    } catch (e) {
      print("Something happened in saveImageFile method");
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<MailResponse> processImage(String imagePath) async {
    CloudVisionApi vision = CloudVisionApi();
    print("processImage: " + imagePath);
    var image = File(imagePath);
    var imageByte;
    imageByte = image.readAsBytesSync();

    var a = base64.encode(imageByte);
    print(a);
    var objMr = await vision.search(a);
    for (var address in objMr.addresses) {
      address.validated =
          await UspsAddressVerification().verifyAddressString(address.address);
    }
    _barcodeScannerApi = BarcodeScannerApi();
    File img = File(filePath);
    _barcodeScannerApi!.setImageFromFile(img);

    List<CodeObject> codes = await _barcodeScannerApi!.processImage();
    for (final code in codes) {
      objMr.codes.add(code);
    }
    print(objMr.toJson());
    return objMr;
  }
}
