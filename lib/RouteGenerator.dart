import 'package:flutter/material.dart';
import 'package:summer2022/enough_mail_sample.dart';
import './mail_widget.dart';
import './main_menu.dart';
import './other_mail.dart';
import './settings.dart';
import './sign_in.dart';
import './backend_testing.dart';
import 'models/Arguments.dart';
import 'models/EmailArguments.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('setting.name:  ${settings.name}');
    switch (settings.name) {
      case '/main':
        return MaterialPageRoute(builder: (_) => MainWidget());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/digest_mail':
        return MaterialPageRoute(builder: (_) => MailWidget(digest: (settings.arguments as MailWidgetArguments).digest));
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInWidget());
      case '/other_mail':
        return MaterialPageRoute(builder: (_) => OtherMailWidget(emails: (settings.arguments as EmailWidgetArguments).emails));
      case '/backend_testing':
        return MaterialPageRoute(
            builder: (_) => BackendPage(title: "Backend Testing"));
      case '/enough_mail_sample':
        return MaterialPageRoute(
            builder: (_) => EnoughMailPage(title: "Enough Mail Sample"));
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
