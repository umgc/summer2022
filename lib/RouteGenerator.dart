import 'package:flutter/material.dart';
import './mail_widget.dart';
import './main_menu.dart';
import './other_mail.dart';
import './settings.dart';
import './sign_in.dart';
import './backend_testing.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('setting.name:  ${settings.name}');
    switch (settings.name) {
      case '/main':
        return MaterialPageRoute(builder: (_) => MainWidget());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/digest_mail':
        return MaterialPageRoute(builder: (_) => MailWidget());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInWidget());
      case '/other_mail':
        return MaterialPageRoute(builder: (_) => OtherMailWidget());
      case '/backend_testing':
        return MaterialPageRoute(
            builder: (_) => BackendPage(title: "Backend Testing"));
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
