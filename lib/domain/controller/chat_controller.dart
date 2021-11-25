import 'package:f_202110_firebase/data/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.reference();
  var messages = <Message>[].obs;

  start() {
    databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded);
  }

  stop() {
    databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded)
        .cancel();
  }

  _onEntryAdded(Event event) {
    print("Something was added");
    messages.add(Message.fromSnapshot(event.snapshot));
  }

  Future<void> sendMsg(String text) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      databaseReference
          .child("fluttermessages")
          .push()
          .set({'text': text, 'uid': uid});
    } catch (error) {
      print("Error sending msg");
      return Future.error(error);
    }
  }
}
