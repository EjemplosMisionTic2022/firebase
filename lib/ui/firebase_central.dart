import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/authentication/firebase_login.dart';
import 'pages/content_page.dart';

class FirebaseCentral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ContentPage();
        } else {
          return FirebaseLogIn();
        }
      },
    );
  }
}
