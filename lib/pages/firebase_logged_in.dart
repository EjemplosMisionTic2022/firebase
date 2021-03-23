import 'package:f_202110_firebase/pages/chat_page.dart';
import 'package:f_202110_firebase/pages/firestore_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseLoggedIn extends StatefulWidget {
  const FirebaseLoggedIn({Key key}) : super(key: key);

  @override
  _FirebaseLoggedInState createState() => _FirebaseLoggedInState();
}

class _FirebaseLoggedInState extends State<FirebaseLoggedIn> {
  int _selectIndex = 0;

  static List<Widget> _widgets = <Widget>[FireStorePage(), ChatPage()];

  _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Basic Firebase operations"), actions: [
        IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _logout();
            }),
      ]),
      body: _widgets.elementAt(_selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Firestore"),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: "Chat")
        ],
        currentIndex: _selectIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
