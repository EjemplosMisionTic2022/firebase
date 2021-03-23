import 'package:f_202110_firebase/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController _controller;
  ScrollController _scrollController;
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    print("Something was added");
    setState(() {
      messages.add(Message.fromSnapshot(event.snapshot));
      _needsScroll = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _item(Message element, int posicion, String uid) {
    print('user -> ${element.user}');
    print(uid == element.user);
    return Card(
      margin: EdgeInsets.all(4.0),
      color: uid == element.user ? Colors.yellow[200] : Colors.grey[300],
      child: ListTile(
        title: Text(
          element.text,
          textAlign: uid == element.user ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _list() {
    String uid = FirebaseAuth.instance.currentUser.uid;
    print('Current user $uid');
    return ListView.builder(
      itemCount: messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        var element = messages[index];
        return _item(element, index, uid);
      },
    );
  }

  Future<String> _sendMsg(String text) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      databaseReference
          .child("fluttermessages")
          .push()
          .set({'text': text, 'uid': uid});
    } catch (error) {
      print("Error sending msg");
      return Future.error(error);
    }
    return Future.value("ok");
  }

  Widget _textInput() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your message',
              ),
              controller: _controller,
            ),
          ),
        ),
        TextButton(
            child: Text('Send'),
            onPressed: () {
              _sendMsg(_controller.text);
              _controller.clear();
            })
      ],
    );
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Container(
      child: Column(
        children: [Expanded(flex: 4, child: _list()), _textInput()],
      ),
    );
  }
}
