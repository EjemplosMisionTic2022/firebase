import 'package:f_202110_firebase/pages/base/firebase_logged_in.dart';
import 'package:f_202110_firebase/pages/authentication/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseCentral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FirebaseLoggedIn();
        } else {
          return FirebaseLogIn();
        }
      },
    );
  }
}
