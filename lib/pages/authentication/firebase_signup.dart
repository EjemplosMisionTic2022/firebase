import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseSignUp extends StatefulWidget {
  @override
  _FirebaseSignUpState createState() => _FirebaseSignUpState();
}

class _FirebaseSignUpState extends State<FirebaseSignUp> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  Future<void> _signup(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _buildDialog(context, "Sign up", "Sign up ok").then((value) {
        _formKey.currentState.reset();
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  Future<void> _buildDialog(BuildContext context, String _title, String _msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_title),
            content: Text(_msg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up Information",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: this.controllerEmail,
                          decoration:
                              InputDecoration(labelText: "Email address"),
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
                        TextButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              form.save();
                              if (_formKey.currentState.validate()) {
                                _signup(context, controllerEmail.text,
                                    controllerPassword.text);
                              }
                            },
                            child: Text("Submit")),
                      ]),
                ))));
  }
}
