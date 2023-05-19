import 'dart:math';

import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/controllers/authenticationmodels.dart';
import 'package:com.example.wheel_of_life/controllers/usercontroller.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final authRepo = Get.put(AuthRepo());
  final userrepo = Get.put(UserRepo());
  //fetch records query
  getUserData() {
    final email = authRepo.firebaseUser.value?.email;
    if (email != null) {
      return userrepo.getUserDetails(email);
    } else {
      //Get.snackbar("Error", "Login to Continue");
    }
  }
}
