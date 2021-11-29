import 'package:f_202110_firebase/data/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class ChatController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.reference();
  var messages = <Message>[].obs;

  //Método start para comenzar a escuchar la colección de documentos FlutterMessages,   
  //que contiene el mensaje a enviar en los chats   
  // start() {}

  //Método onEntryChanged listener  
  //para añadir al listado los mensajes que llegan de la db
  // _onEntryChanged(Event event) {}

  //Método stop para dejar de escuchar la colección
  // stop() {}

  _onEntryAdded(Event event) {
    print("Something was added");
    messages.add(Message.fromSnapshot(event.snapshot));
  }

  //Método sendmsg para enviar un nuevo mensaje
  // Future<void> sendMsg(String text) async {}

  Future<void> updateMsg(Message message) async {
    logInfo('updateMsg with key ${message.key}');
    try {
      databaseReference
          .child("fluttermessages")
          .child(message.key)
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
          .child(message.key)
          .remove()
          .then((value) => messages.removeAt(index));
    } catch (error) {
      logError("Error deleting msg $error");
      return Future.error(error);
    }
  }
}
