import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:summer2022/backend_testing.dart';
import 'package:summer2022/models/Code.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  Widget backendTestWidget(Widget widget) {
    return MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget));
  }

  setUpAll(() {
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider_macos',
    );
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getApplicationDocumentsDirectory':
          return "test/data";
        default:
      }
    });

    const mlkit = MethodChannel('google_mlkit_barcode_scanning');
    mlkit.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'vision#startBarcodeScanner') {
        return <codeObject>[];
      }
      return null;
    });
  });

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

    //Tap ML Kit QR Codes/Barcodes Image Scan button
    await tester.tap(find.text("ML Kit  QR Codes/Barcodes Image Scan"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // expect(
    //     find.text('{type: qr, info: https://qrco.de/bczuEB}'), findsOneWidget);
  });
}
