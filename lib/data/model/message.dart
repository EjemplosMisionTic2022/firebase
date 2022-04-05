import 'package:firebase_database/firebase_database.dart';

class Message {
  String? key;
  String text;
  String user;

  Message(this.key, this.text, this.user);

  Message.fromSnapshot(DataSnapshot snapshot)
      : assert(snapshot.value['text'] != null),
        assert(snapshot.value['user'] != null),
        key = snapshot.key ?? "0",
        text = snapshot.value["text"],
        user = snapshot.value["user"];

  Message.fromJson(Map<dynamic, dynamic> json)
      : key = json['uid'] ?? "0",
        user = json['user'] as String,
        text = json['text'] as String;

  toJson() {
    return {
      "text": text,
      "user": user,
    };
  }
}
