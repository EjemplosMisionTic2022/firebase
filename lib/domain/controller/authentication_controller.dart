import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationController extends GetxController {

  //Crea el futuro para iniciar sesion, deben recibirse como params el email y contraseña
  // Future<void> login(theEmail, thePassword) async {}

  //Crea el futuro para el registro de nuevos usuarios, deben recibirse como params el email y contraseña
  // Future<void> signUp(email, password) async {}


   //Crea el futuro para cerrar sesion
  // Future<void> logOut() async {}
  
  String userEmail() {
    String email = FirebaseAuth.instance.currentUser!.email ?? "a@a.com";
    return email;
  }
}
