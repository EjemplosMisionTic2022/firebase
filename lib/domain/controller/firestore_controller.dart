import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_202110_firebase/data/model/record.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class FirebaseController extends GetxController {
  var _records = <Record>[].obs;

  List<Record> get entries => _records;
  final CollectionReference baby =
      FirebaseFirestore.instance.collection('baby');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('baby').snapshots();

  @override
  void onInit() {
    suscribeUpdates();
    super.onInit();
  }

  suscribeUpdates() async {
    logInfo('suscribeLocationUpdates');
    _usersStream.listen((event) {
      logInfo('Got new item from fireStore');
      _records.clear();
      event.docs.forEach((element) {
        _records.add(Record.fromSnapshot(element));
      });
      print('Got ${_records.length}');
    });
  }

  addEntry(name) {
    baby
        .add({'name': name, 'votes': 0})
        .then((value) => print("Baby added"))
        .catchError((onError) => print("Failed to add baby $onError"));
  }
}
