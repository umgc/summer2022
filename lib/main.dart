import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_test/EmailContent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'enough_mail.dart';
import 'package:intl/date_time_patterns.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Enough Mail Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    print('Test Click: ' + index.toString());
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate.subtract(Duration(days: 7)),
      lastDate: currentDate,
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    var menu = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: _discoverTest,
              //     child: Text("Discover Email"),
              //   ),
              // ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _imapTest,
                  child: Text("Fetch Email using IMAP"),
                ),
              ),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: _smtpTest,
              //     child: Text("SMTP Email"),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
    var emails2 = Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: emailsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              margin: EdgeInsets.all(5),

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
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 24, 162, 226)),
                      width: double.infinity,
                      child: Text('${emailsList[index]}'))),
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
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text("Choose Date"),
                ),
                Text(
                    "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}")
              ],
            ),
          ),
          menu,
          emails2,
        ],
      ),
    );
  }
}
