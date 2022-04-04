import 'package:firebase_database/firebase_database.dart';

class Message {
  String? key;
  String text;
  String user;

  Message(this.key, this.text, this.user);

  Message.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key ?? "0",
        text = "",
        user = "";

  Message.fromJson(Map<dynamic, dynamic> json)
      : key = json['uid'] ?? "0",
        user = json['uid'] as String,
        text = json['text'] as String;

  toJson() {
    return {
      "text": text,
      "user": user,
    };
  }
}
