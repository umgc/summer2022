import 'package:enough_mail/enough_mail.dart';
import './EmailContent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './enough_mail.dart';

void main() {
  runApp(const EnoughMail());
}

class EnoughMail extends StatelessWidget {
  const EnoughMail({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EnoughMailPage(title: 'Enough Mail Test'),
    );
  }
}

class EnoughMailPage extends StatefulWidget {
  const EnoughMailPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<EnoughMailPage> createState() => _EnoughMailPageState();
}

class _EnoughMailPageState extends State<EnoughMailPage> {
  List<MimeMessage> emails = [];
  List<String> emailsList = [];
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  void _discoverTest() {
    discoverExample();
    setState(() {});
  }

  void _imapTest() async {
    emails = await imapExample();
    emailsList.clear();
    var s = '';

    for (var email in emails) {
      var date =
          DateFormat("EEEE dd-MM-yyyy hh:mm").format(email.decodeDate()!);
      s = "${email.from![0].personalName} | ${date.toString()}\nSubject: ${email.decodeSubject()}";
      DateFormat("EEEE MM-dd-yyyy").format(email.decodeDate()!);

      setState(() {
        emailsList.add(s);
      });

      s = '';
    }
  }

  void _smtpTest() {
    smtpExample();
    setState(() {});
  }

  void addEmails(List<ListTile> emails) {}
  void resetEmailWidget() {}
  _test(int index) {
    print('Test Click: $index');
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate.subtract(const Duration(days: 7)),
      lastDate: currentDate,
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var menu = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _imapTest,
                child: const Text("Fetch Email using IMAP"),
              ),
            ),
          ],
        ),
      ],
    );
    var emails2 = Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: emailsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              margin: const EdgeInsets.all(5),

              // child: Container(
              child: ElevatedButton(
                  // onPressed: null,
                  //onPressed: EmailContent(emails.elementAt(index)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailContent(
                                emails,
                                index: index,
                              )),
                    );
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 24, 162, 226)),
                      width: double.infinity,
                      child: Text(emailsList[index]))),
              // ),
            );
          }),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: const Text("Choose Date"),
              ),
              Text(
                  "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}")
            ],
          ),
          menu,
          emails2,
        ],
      ),
    );
  }
}
