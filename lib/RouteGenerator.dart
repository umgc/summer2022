import 'package:flutter/material.dart';
import 'package:summer2022/mail_widget.dart';
import 'package:summer2022/main_menu.dart';
import 'package:summer2022/other_mail.dart';
import 'package:summer2022/settings.dart';
import 'package:summer2022/sign_in.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('setting.name:  ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainWidget());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/digest_mail':
        return MaterialPageRoute(builder: (_) => MailWidget());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInWidget());
      case '/other_mail':
        return MaterialPageRoute(builder: (_) => OtherMailWidget());
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
