import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_202110_firebase/data/model/record.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class FirebaseController extends GetxController {
  var _records = <Record>[].obs;

  List<Record> get entries => _records;
  
  //Implementa los getters necesarios para los datos y el stream


  @override
  void onInit() {
    suscribeUpdates();
    super.onInit();
  }

  //Implementa el metodo para suscribirse a cambios en lo datos
  suscribeUpdates() async {}

  //Implementa el metodo para agregar datos en firestore
  addEntry(name) { }
}
