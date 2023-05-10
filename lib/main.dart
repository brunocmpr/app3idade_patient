import 'package:app3idade_patient/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App3Idade());
}

class App3Idade extends StatelessWidget {
  const App3Idade({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3ª Idade Fácil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.login,
      routes: Routes.routes,
    );
  }
}
