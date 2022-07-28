import 'package:flutter/material.dart';
import 'package:summer2022/enough_mail_sample.dart';
import 'ui/mail_widget.dart';
import 'ui/main_menu.dart';
import 'ui/other_mail.dart';
import 'ui/settings.dart';
import 'ui/sign_in.dart';
import './backend_testing.dart';
import 'models/Arguments.dart';
import 'models/EmailArguments.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('setting.name:  ${settings.name}');
    switch (settings.name) {
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainWidget());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsWidget());
      case '/digest_mail':
        return MaterialPageRoute(
            builder: (_) => MailWidget(
                digest: (settings.arguments as MailWidgetArguments).digest));
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInWidget());
      case '/other_mail':
        return MaterialPageRoute(
            builder: (_) => OtherMailWidget(
                emails: (settings.arguments as EmailWidgetArguments).emails));
      case '/backend_testing':
        return MaterialPageRoute(
            builder: (_) => const BackendPage(title: "Backend Testing"));
      case '/enough_mail_sample':
        return MaterialPageRoute(
            builder: (_) => const EnoughMailPage(title: "Enough Mail Sample"));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text("No route for ${settings.name}"),
          ));
        });
    }
  }
}
