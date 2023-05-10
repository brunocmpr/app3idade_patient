import 'package:app3idade_patient/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String token;
  final AuthService _authService = AuthService();

  HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are logged in! Token: $token',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                await _authService.logoutAndGoToLogin(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
