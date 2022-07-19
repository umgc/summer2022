import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:summer2022/digest_email_parser.dart';
import 'package:summer2022/other_mail_parser.dart';
import './Client.dart';
import './keychain.dart';
import 'package:toggle_switch/toggle_switch.dart';
import './backend_testing.dart';
import 'models/Arguments.dart';
import 'models/EmailArguments.dart';
import 'models/Digest.dart';

class MainWidget extends StatefulWidget {
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  DateTime selected_date = DateTime.now();
  String mail_type = "Email";
  @override
  Widget build(BuildContext context) {
    String formattedDate_selected_date = DateFormat('yyyy-MM-dd').format(selected_date);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => selectDate(context),
                    icon: Icon(Icons.calendar_month_outlined),
                    label: Text("$formattedDate_selected_date"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),/*
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child:
                  ),*/
                  Text("Mail Type:"),
                  DropdownButton(
                      value: mail_type,
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
                          mail_type = valueSelected!;
                        });
                      }),
                ],
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt_outlined),
                  label: const Text("Scan Mail"),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
                /*child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                ),*/
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: OutlinedButton(
                      onPressed: () async {
                        if (mail_type == "Email") {
                          context.loaderOverlay.show();
                          await getEmails(false, DateTime.now());
                          if(emails.isNotEmpty) {
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
                      child: const Text("Recent",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Container(
                    child: OutlinedButton(
                      onPressed: () async {
                        if (mail_type == "Email") {
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
                      child: const Text("Unread",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text("Settings",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/backend_testing');
                      },
                      child: const Text("Backend Testing",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/enough_mail_sample');
                      },
                      child: const Text("Enough Mail Tester",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shadowColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () async {
                    //Add logic to remove the credentials from the secure storage
                    Keychain().deleteAll();
                    //TODO: Make sure Client logs out not sure if I need to?
                    Navigator.pushNamed(context, '/sign_in');
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if ((picked != null) && (picked != selected_date)) {/*
      if (mail_type == "Email") {
        context.loaderOverlay.show();
        await getEmails(false, picked);
        if(emails.isNotEmpty) {
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
*/
      setState(() {
        selected_date = picked;
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
                "There is no Digest available for the selected date: ${selected_date.month}/${selected_date.day}/${selected_date.year}",
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
            height: 80.0, // Change as per your requirement
            width: 100.0, // Change as per your requirement
            child: Center( child : Text(
              "There are no emails available for the selected date: ${selected_date.month}/${selected_date.day}/${selected_date.year}",
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
        initialDate: selected_date,
        firstDate: DateTime(1970),
        lastDate: DateTime.now());
    if ((picked != null) && (picked != selected_date)) {
      context.loaderOverlay.show();
      await getEmails(false, DateTime.now());
      if((emails.isNotEmpty)) {
        Navigator.pushNamed(context, '/other_mail', arguments: EmailWidgetArguments(emails));
      } else {
        showNoEmailsDialog();
      }
      context.loaderOverlay.hide();
      setState(() {
        //selected_date = picked;
      });
    }
  }

  late Digest digest;
  late List<Digest> emails;

  Future<void> getDigest([DateTime? pickedDate]) async {
    await DigestEmailParser().createDigest(await Keychain().getUsername(), await Keychain().getPassword(), pickedDate ?? selected_date).then((value) => digest = value);
  }

  Future<void> getEmails(bool isUnread, [DateTime? pickedDate]) async {
    await OtherMailParser().createEmailList(isUnread, await Keychain().getUsername(), await Keychain().getPassword(), pickedDate ?? selected_date).then((value) => emails = value);
  }
}
