import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:com.example.wheel_of_life/controllers/exceptionhandling.dart';
import 'package:com.example.wheel_of_life/view/authview/login.dart';

import '../view/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

import '../view/splash.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.put(AuthRepo());
  final auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;
  @override
  void onready() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setinitialScreen);
  }

  _setinitialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplashScreen())
        : Get.offAll(() => const Home());
  }

  Future<void> createUserWithEmailAndPassword(String email, String pass) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      firebaseUser.value != null
          ? Get.offAll(() => const Home())
          : Get.offAll(() => SplashScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignupEmailFailure(e.code);
      print('Firebase Auth Exception - ${ex.message}');
      throw ex;
    } catch (_) {}
  }

  Future<void> loginWithEmailAndPassword(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
    } catch (_) {}
  }

  Future<void> logout() async => await auth.signOut();
}
