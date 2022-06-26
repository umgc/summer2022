import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainWidget extends StatefulWidget {
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 3, 5),
                        maxTime: DateTime(2019, 6, 7), onConfirm: (date) {
                      print('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Choose a Digest Date',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Spacer(),
                Icon(Icons.search, size: 50),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      backgroundColor: Colors.grey,
                      b),
                  onPressed: () {
                    print("Opening camera for scan");
                  },
                  child: Text("Scan Mail"),
                ),
                Icon(Icons.camera_alt_outlined, size: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
