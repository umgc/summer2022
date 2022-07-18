import 'package:flutter_test/flutter_test.dart';
import 'package:summer2022/command_tutorial.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("Command Tutorial", () {
    String error = '';
    try {
      CommandTutorial commandTutorial = CommandTutorial();
      commandTutorial.runTutorial();
    } catch (e) {
      error = e.toString();
    }
    expect(error, '');
  });
}