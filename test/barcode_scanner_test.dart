import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:summer2022/backend_testing.dart';
import '../lib/models/Code.dart';
import '../lib/barcode_scanner.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  Widget backendTestWidget(Widget widget) {
    return MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Scan barcode with result', (tester) async {
    await tester
        .pumpWidget(backendTestWidget(const BackendPage(title: 'Test')));

    //Get image from dropdown list - set file
    final dropdown = find.byKey(const ValueKey('dropdown'));

    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final dropdownItem = find.text('mail.test.03.png').last;

    await tester.tap(dropdownItem);
    await tester.pumpAndSettle();

    // //Tap ML Kit QR Codes/Barcodes Image Scan button
    await tester.tap(find.text("ML Kit  QR Codes/Barcodes Image Scan"));
    await tester.pumpAndSettle();

    // expect(
    //     find.text('{type: qr, info: https://qrco.de/bczuEB}'), findsOneWidget);
  });
}
