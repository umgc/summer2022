import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:intl/intl.dart';
import '../imageProcessing.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:summer2022/digest_email_parser.dart';
import 'package:summer2022/other_mail_parser.dart';
import 'package:summer2022/usps_address_verification.dart';
import '../Client.dart';
import '../Keychain.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../backend_testing.dart';
import '../api.dart';
import '../main.dart';
import '../models/Arguments.dart';
import '../models/EmailArguments.dart';
import '../models/Digest.dart';
import '../models/MailResponse.dart';
import 'bottom_app_bar.dart';

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
  FontWeight commonFontWt = FontWeight.w700;
  double commonFontSize = 32;
  double commonBorderWidth = 2;
  double commonButtonHeight = 60;
  double commonCornerRadius = 8;

  @override
  void initState() {
    super.initState();
    stt.setCurrentPage("main");
  }

  ButtonStyle commonButtonStyleElevated(Color? primary, Color? shadow)
  {
    return ElevatedButton.styleFrom(
      textStyle: TextStyle(fontWeight: FontWeight.w700,fontSize: commonFontSize),
      primary: primary,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(commonCornerRadius))),
      side: BorderSide( width: commonBorderWidth, color: Colors.black ),
    );
  }

  ButtonStyle commonButtonStyleText(Color? primary, Color? shadow)
  {
    return TextButton.styleFrom(
      textStyle: TextStyle(fontWeight: commonFontWt,fontSize: commonFontSize),
      primary: primary,
      shadowColor: shadow,

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(commonCornerRadius))),
      side: BorderSide( width: commonBorderWidth, color: Colors.black ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
        bottomNavigationBar: BottomBar(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Main Menu", style: TextStyle(fontWeight: commonFontWt,fontSize: commonFontSize),),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey,
        ),
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: commonButtonHeight,
                            child: OutlinedButton.icon(
                              onPressed: () => selectDate(context),
                              icon: Icon(
                                Icons.calendar_month_outlined,
                                size: 35,
                              ),
                              label: Text("$formattedSelectedDate"),
                              style: commonButtonStyleText(Colors.black, Colors.grey),
                            ),
                          ),
                          SizedBox(height: commonButtonHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.grey.shade300, //background color of dropdown button
                                borderRadius: BorderRadius.circular(commonCornerRadius), //border raiuds of dropdown button
                              ),
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/settings');
                                },
                                icon: Icon(
                                  Icons.settings,
                                  size: 50,
                                ),
                                label: Text(""),
                                style: commonButtonStyleText(Colors.black, Colors.blue),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Padding( // MODE Dialog Box
                    padding: EdgeInsets.only(top:0, left: 65, right: 65),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: commonButtonHeight, width:13 ,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.grey.shade200, //background color of dropdown button
                                border: Border.all(color: Colors.black, width:commonBorderWidth), //border of dropdown button
                                borderRadius: BorderRadius.circular(commonCornerRadius), //border raiuds of dropdown button
                              ),
                              child:Padding(
                                padding: EdgeInsets.only(left:30),
                                child: DropdownButtonHideUnderline(
                                  child:DropdownButton(
                                      value: mailType,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "Email",
                                          child: Text("Email Mode", style: TextStyle(fontWeight: commonFontWt, fontSize: commonFontSize)),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: "Digest",
                                          child: Text("Digest Mode", style: TextStyle(fontWeight: commonFontWt, fontSize: commonFontSize)),
                                        ),
                                      ],
                                      onChanged: (String? valueSelected) {
                                        setState(() {
                                          mailType = valueSelected!;
                                        });
                                  })
                                ),
                              ),
                            )
                          ),
                        ),
                      ]
                    ),
                  ),

                  Padding( // MODE Dialog Box
                    padding: EdgeInsets.only(top:0, left: 30, right: 30),
                    child: Row( // LATEST and UNREAD Buttons
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: commonButtonHeight, // LATEST Button
                          child: OutlinedButton(
                            onPressed: () async {
                              if (mailType == "Email") {
                                context.loaderOverlay.show();
                                await getEmails(false, DateTime.now());
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
                            style: commonButtonStyleElevated(Colors.white, Colors.grey),
                            child: const Text("Latest",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(height: commonButtonHeight, // UNREAD Button
                          child: OutlinedButton(
                            onPressed: () async {
                              if (mailType == "Email") {
                                context.loaderOverlay.show();
                                await getEmails(true, DateTime.now());
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
                            style: commonButtonStyleElevated(Colors.white, Colors.grey),
                            child: const Text("Unread", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: commonButtonHeight, // SCAN MAIL Button
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:Colors.grey.shade400, //background color of dropdown button
                        borderRadius: BorderRadius.circular(commonCornerRadius), //border raiuds of dropdown button
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final PickedFile =
                          await picker.getImage(source: ImageSource.camera);
                          print(PickedFile!.path);
                          if (PickedFile != null) {
                            _image = File(PickedFile.path);
                            _imageBytes = _image!.readAsBytesSync();
                            await deleteImageFiles();
                            await saveImageFile(_imageBytes!, "mailpiece.jpg");
                            MailResponse s =
                            await processImage("${imagePath}/mailpiece.jpg");
                            print(s.toJson());
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                        ),
                        label: const Text("Scan Mail"),
                        style: commonButtonStyleText(Colors.black, Colors.grey),
                      ),
                    ),
                  ),
                  Padding( // MODE Dialog Box
                    padding: EdgeInsets.only(top:0, bottom: 20),
                    child: SizedBox(height: commonButtonHeight,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_in');
                        },
                        style: commonButtonStyleElevated(Colors.black, Colors.grey),
                        child: const Text(
                          "  Sign Out  ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  /*SizedBox(height: commonButtonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/backend_testing');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const BackendPage(
                        //               title: "USPS Backend Testing",
                        //             )));
                      },
                      style: commonButtonStyleElevated(Colors.grey, Colors.grey),
                      child: const Text("Backend Testing",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),*/
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
        await getEmails(false, picked);
        if ((emails.isNotEmpty)) {
          Navigator.pushNamed(context, '/other_mail',
              arguments: EmailWidgetArguments(emails));
        } else {
          showNoEmailsDialog();
        }
        context.loaderOverlay.hide();
      } else {
        context.loaderOverlay.show();
        await getDigest(picked);
        if (!digest.isNull()) {
          Navigator.pushNamed(context, '/digest_mail',
              arguments: MailWidgetArguments(digest));
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
          title: Center(
            child: Text("No Digest Available"),
          ),
          content: Container(
            height: 100.0, // Change as per your requirement
            width: 100.0, // Change as per your requirement
            child: Center(
              child: Text(
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
          title: Center(
            child: Text("No Emails Available"),
          ),
          content: Container(
            height: 100.0, // Change as per your requirement
            width: 100.0, // Change as per your requirement
            child: Center(
              child: Text(
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
      await getEmails(false, picked);
      if ((emails.isNotEmpty)) {
        Navigator.pushNamed(context, '/other_mail',
            arguments: EmailWidgetArguments(emails));
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
    await DigestEmailParser()
        .createDigest(await Keychain().getUsername(),
            await Keychain().getPassword(), pickedDate ?? selectedDate)
        .then((value) => digest = value);
  }

  Future<void> getEmails(bool isUnread, [DateTime? pickedDate]) async {
    await OtherMailParser()
        .createEmailList(isUnread, await Keychain().getUsername(),
            await Keychain().getPassword(), pickedDate ?? selectedDate)
        .then((value) => emails = value);
  }
}
