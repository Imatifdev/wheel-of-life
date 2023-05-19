import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/controllers/usercontroller.dart';
import 'package:com.example.wheel_of_life/models/usermodel.dart';

import 'authenticationmodels.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final email = TextEditingController();
  final fname = TextEditingController();

  final lname = TextEditingController();

  final phone = TextEditingController();

  final pass = TextEditingController();
  final userrepo = Get.put(UserRepo());
  void registeruser(String email, String pass) {
    //String? error =
    AuthRepo.instance.createUserWithEmailAndPassword(email, pass);
    //as String?;
    // if (error != null) {
    //   Get.showSnackbar(GetSnackBar(message: error.toString()));
    // }
  }

  Future<void> createUser(UserModel user) async {
    await userrepo.createUser(user);
  }
}
