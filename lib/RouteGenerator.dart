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
      case '/':
        return MaterialPageRoute(builder: (_) => const MainWidget());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsWidget());
      case '/digest_mail':
        return MaterialPageRoute(builder: (_) => const MailWidget());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInWidget());
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
