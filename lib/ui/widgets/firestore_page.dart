import 'package:f_202110_firebase/data/model/record.dart';
import 'package:f_202110_firebase/domain/controller/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class FireStorePage extends StatefulWidget {
  @override
  State<FireStorePage> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {
  final FirebaseController firebaseController = Get.find();

  @override
  void initState() {
    firebaseController.suscribeUpdates();
    super.initState();
  }

  @override
  void dispose() {
    firebaseController.unsuscribeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => ListView.builder(
              itemCount: firebaseController.entries.length,
              padding: EdgeInsets.only(top: 20.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, firebaseController.entries[index]);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            addBaby(context);
          },
        ));
  }

  Widget _buildItem(BuildContext context, Record record) {
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
          onTap: () => firebaseController.updateEntry(record),
          onLongPress: () => firebaseController.deleteEntry(record),
        ),
      ),
    );
  }

  Future<void> addBaby(BuildContext context) async {
    getName(context).then((value) {
      firebaseController.addEntry(value);
    });
  }

  Future<String> getName(BuildContext context) async {
    String? result = await prompt(
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
}
