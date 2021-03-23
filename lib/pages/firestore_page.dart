import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_202110_firebase/model/record.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class FireStorePage extends StatelessWidget {
  CollectionReference baby = FirebaseFirestore.instance.collection('baby');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Future<void> addBaby(BuildContext context) {
    getName(context).then((value) {
      return baby
          .add({'name': value, 'votes': 0})
          .then((value) => print("Baby added"))
          .catchError((onError) => print("Failed to add baby $onError"));
    });
  }

  Future<String> getName(BuildContext context) async {
    String result = await prompt(
      context,
      title: Text('Adding a baby'),
      initialValue: '',
      textOK: Text('Ok'),
      textCancel: Text('Cancel'),
      hintText: 'Baby name',
      minLines: 1,
      autoFocus: true,
      obscureText: false,
      textCapitalization: TextCapitalization.words,
    );
    if (result != null) {
      return Future.value(result);
    }
    return Future.error('cancel');
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildItem(context, data)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addBaby(context);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () {
            record.reference.update({'votes': record.votes + 1});
          },
        ),
      ),
    );
  }
}
