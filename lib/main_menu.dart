import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:summer2022/digest_email_parser.dart';
import 'package:summer2022/other_mail_parser.dart';
import 'package:summer2022/usps_address_verification.dart';
import './Client.dart';
import './keychain.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './backend_testing.dart';
import 'api.dart';
import 'models/Arguments.dart';
import 'models/EmailArguments.dart';
import 'models/Digest.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  MainWidgetState createState() => MainWidgetState();
}

CloudVisionApi? vision = CloudVisionApi();

class MainWidgetState extends State<MainWidget> {
  DateTime selectedDate = DateTime.now();
  String mailType = "Email";
  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: OutlinedButton.icon(
                      onPressed: () => selectDate(context),
                      icon: Icon(Icons.calendar_month_outlined),
                      label: Text("$mailType Date Selection"),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Text("Mail Type:"),
                  DropdownButton(
                      value: mailType,
                      items: [
                        DropdownMenuItem<String>(
                          value: "Email",
                          child: Text("Email"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Digest",
                          child: Text("Digest"),
                        ),
                      ],
                      onChanged: (String? valueSelected) {
                        setState(() {
                          mailType = valueSelected!;
                        });
                      }),
                ],
              ),
            ),
            Container(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      void _getImage() async {
                        final PickedFile = await picker.getImage(source: ImageSource.camera);
                        print(PickedFile!.path);
                        if (PickedFile != null) {
                          _image = File(PickedFile.path);

                          _imageBytes = _image!.readAsBytesSync();
                          String a = base64.encode(_imageBytes!);
                          var objMailResponse = await vision!.search(a);
                          for (var address in objMailResponse.addresses) {
                            address.validated = await UspsAddressVerification()
                                .verifyAddressString(address.address);
                          }
                          setState(() {
                            if (PickedFile != null) {
                              _image = File(PickedFile.path);
                              _imageBytes = _image!.readAsBytesSync();
                              _imageName = _image!.path.split('/').last;
                            } else {
                              print('No image selected.');
                            }
                          });
                        }
                      }
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                    label: const Text("Scan Mail"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/backend_testing');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const BackendPage(
                //               title: "USPS Backend Testing",
                //             )));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shadowColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              child: const Text("Backend Testing",
                  style: TextStyle(color: Colors.black)),
            ),
            Container(
              child: Column(
              children: [
              Center(
                child: Column(
                  children: [
                  OutlinedButton(
                  onPressed: () async {
                    if (mailType == "Email") {
                      context.loaderOverlay.show();
                      await getEmails();
                      if((emails.isNotEmpty)) {
                        Navigator.pushNamed(context, '/other_mail', arguments: EmailWidgetArguments(emails));
                      } else {
                        showNoEmailsDialog();
                      }
                      context.loaderOverlay.hide();
                    } else {
                      context.loaderOverlay.show();
                      await getDigest();
                      if(!digest.isNull()) {
                        Navigator.pushNamed(context, '/digest_mail', arguments: MailWidgetArguments(digest));
                      } else {
                        showNoDigestDialog();
                      }
                      context.loaderOverlay.hide();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: const Text("Latest",
                      style: TextStyle(color: Colors.black)),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (mailType == "Email") {
                        context.loaderOverlay.show();
                        await getEmails();
                        if((emails.isNotEmpty)) {
                          Navigator.pushNamed(context, '/other_mail', arguments: EmailWidgetArguments(emails));
                        } else {
                          showNoEmailsDialog();
                        }
                        context.loaderOverlay.hide();
                      } else {
                        context.loaderOverlay.show();
                        await getDigest();
                        if(!digest.isNull()) {
                          Navigator.pushNamed(context, '/digest_mail', arguments: MailWidgetArguments(digest));
                        } else {
                          showNoDigestDialog();
                        }
                        context.loaderOverlay.hide();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: const Text("Unread",
                      style: TextStyle(color: Colors.black)),
                  ),
                ]
              ),
              ),
              Center(
                child : OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                 ),
                  child: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_in');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ] // Children
          ),
      ),
    ])));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selectedDate)) {
      if (mailType == "Email") {
        context.loaderOverlay.show();
        await getEmails();
        if((emails.isNotEmpty)) {
          Navigator.pushNamed(context, '/other_mail', arguments: EmailWidgetArguments(emails));
        } else {
          showNoEmailsDialog();
        }
        context.loaderOverlay.hide();

      } else {
        context.loaderOverlay.show();
        await getDigest(picked);
        if(!digest.isNull()) {
          Navigator.pushNamed(context, '/digest_mail', arguments: MailWidgetArguments(digest));
        } else {
          showNoDigestDialog();
        }
        context.loaderOverlay.hide();
      }

      setState(() {
        selectedDate = picked;
      });
    }
  }

  void showNoDigestDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center( child : Text(
              "No Digest Available"
            ),
          ),
          content: Container(
            height: 100.0, // Change as per your requirement
            width: 100.0, // Change as per your requirement
            child: Center( child : Text(
                "There is no Digest available for the selected date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }

  void showNoEmailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center( child : Text(
              "No Emails Available"
          ),
          ),
          content: Container(
            height: 100.0, // Change as per your requirement
            width: 100.0, // Change as per your requirement
            child: Center( child : Text(
              "There are no emails available for the selected date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
              style: TextStyle(color: Colors.black),
            ),
            ),
          ),
        );
      },
    );
  }

  Future<void> selectOtherMailDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selectedDate)) {
      context.loaderOverlay.show();
      await getEmails();
      if((emails.isNotEmpty)) {
        Navigator.pushNamed(context, '/other_mail', arguments: EmailWidgetArguments(emails));
      } else {
        showNoEmailsDialog();
      }
      context.loaderOverlay.hide();
      setState(() {
        selectedDate = picked;
      });
    }
  }

  late Digest digest;
  late List<Digest> emails;

  Future<void> getDigest([DateTime? pickedDate]) async {
    await DigestEmailParser().createDigest(await Keychain().getUsername(), await Keychain().getPassword(), pickedDate ?? selectedDate).then((value) => digest = value);
  }

  Future<void> getEmails([DateTime? pickedDate]) async {
    await OtherMailParser().createEmailList(await Keychain().getUsername(), await Keychain().getPassword(), pickedDate ?? selectedDate).then((value) => emails = value);
  }
}
