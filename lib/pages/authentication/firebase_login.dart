import 'package:f_202110_firebase/pages/authentication/firebase_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class FirebaseLogIn extends StatefulWidget {
  const FirebaseLogIn({Key key}) : super(key: key);

  @override
  _FirebaseLogInState createState() => _FirebaseLogInState();
}

class _FirebaseLogInState extends State<FirebaseLogIn> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  _login(theEmail, thePassword) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: theEmail, password: thePassword);
    } catch (e) {
      if (e.code == 'user-not-found') {
        print("user-not-found");
      } else if (e.code == 'wrong-password') {
        print("wrong-password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Login with email",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: this.controllerEmail,
                decoration: InputDecoration(labelText: "Email address"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter email";
                  } else if (!value.contains('@')) {
                    return "Enter valid email address";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: this.controllerPassword,
                decoration: InputDecoration(labelText: "Password"),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter password";
                  } else if (value.length < 6) {
                    return "Password should have at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    form.save();
                    if (_formKey.currentState.validate()) {
                      _login(controllerEmail.text, controllerPassword.text);
                    }
                  },
                  child: Text("Submit")),
            ]),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirebaseSignUp()));
              },
              child: Text("Create account"))
        ],
      ),
    );
  }
}
