import 'package:f_202110_firebase/config/configuration.dart';
import 'package:f_202110_firebase/domain/controller/authentication_controller.dart';
import 'package:f_202110_firebase/domain/controller/chat_controller.dart';
import 'package:f_202110_firebase/domain/controller/firestore_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'firebase_central.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FirestoreController());
    Get.put(ChatController());
    Get.put(AuthenticationController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirebaseCentral());
  }
}
