import 'dart:async';

import 'package:f_202110_firebase/data/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class ChatController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref();
  var messages = <Message>[].obs;
  late StreamSubscription<DatabaseEvent> newEntryStreamSubscription;
  late StreamSubscription<DatabaseEvent> updateEntryStreamSubscription;
  start() {
    messages.clear();
    newEntryStreamSubscription = databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded);

    updateEntryStreamSubscription = databaseReference
        .child("fluttermessages")
        .onChildChanged
        .listen(_onEntryChanged);
  }

  stop() {
    newEntryStreamSubscription.cancel();
    updateEntryStreamSubscription.cancel();
  }

  _onEntryChanged(DatabaseEvent event) {
    print("Something was changed");
    var oldEntry = messages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    final json = event.snapshot.value as Map<dynamic, dynamic>;
    messages[messages.indexOf(oldEntry)] =
        Message.fromJson(event.snapshot, json);
  }

  _onEntryAdded(DatabaseEvent event) {
    print("Something was added");
    final json = event.snapshot.value as Map<dynamic, dynamic>;
    messages.add(Message.fromJson(event.snapshot, json));
  }

  Future<void> sendMsg(String text) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      databaseReference
          .child("fluttermessages")
          .push()
          .set({'text': text, 'uid': uid});
    } catch (error) {
      logError("Error sending msg $error");
      return Future.error(error);
    }
  }

  Future<void> updateMsg(Message message) async {
    logInfo('updateMsg with key ${message.key}');
    try {
      databaseReference
          .child("fluttermessages")
          .child(message.key!)
          .set({'text': 'updated ' + message.text, 'uid': message.user});
    } catch (error) {
      logError("Error updating msg $error");
      return Future.error(error);
    }
  }

  Future<void> deleteMsg(Message message, int index) async {
    logInfo('deleteMsg with key ${message.key}');
    try {
      databaseReference
          .child("fluttermessages")
          .child(message.key!)
          .remove()
          .then((value) => messages.removeAt(index));
    } catch (error) {
      logError("Error deleting msg $error");
      return Future.error(error);
    }
  }
}
