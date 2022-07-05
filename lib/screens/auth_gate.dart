import 'package:barat/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'HomePage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);
  static const routeName = '/auth-gate';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          print("THis is Joe");
          return const LoginPage();
        }
// Render your application if authenticated
        print("THis is not Joe");
        return const HomePage();
      },
    );
  }
}
