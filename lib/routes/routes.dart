import 'package:app3idade_patient/views/home_page.dart';
import 'package:app3idade_patient/views/login_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = '/';
  static const homePage = '/home_page';

  static Map<String, Widget Function(BuildContext)> get routes => {
        login: (context) => const LoginPage(),
        homePage: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(token: arguments);
        },
      };
}
