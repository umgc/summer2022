import 'package:enough_mail/enough_mail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/speech_to_text.dart';
import 'dart:io' as io;

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  test("Process Date", () {
    String error = '';
    try {
      DateTime expectedDt = DateTime(2022, 6, 8);
      Speech speech = Speech();
      DateTime? dt = speech.processDate("June 8th 2022");
      expect(dt, expectedDt);
    } catch (e) {
        error = e.toString();
    }
    expect(error, '');
  });
}