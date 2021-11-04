import 'package:firebase_database/firebase_database.dart';

class Message {
  String? key;
  String text;
  String user;

  Message(this.text, this.user);

  Message.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        text = snapshot.value["text"],
        user = snapshot.value["uid"];

  toJson() {
    return {
      "text": text,
      "user": user,
    };
  }
}
