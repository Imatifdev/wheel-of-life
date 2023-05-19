import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/models/usermodel.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final db = FirebaseFirestore.instance;
  createUser(UserModel user) async {
    await db
        .collection('users')
        .add(user.toJson())
        .whenComplete(() => Get.snackbar(
            "Success", "Your Account has been successfuly created",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.6),
            colorText: Colors.white))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Please try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.white);
      print(error.toString());
    });
  }

//fetch single record
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await db.collection('Users').where('Email', isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userdata;
  }

  //fetch all users
  Future<List<UserModel>> allUsers() async {
    final snapshot = await db.collection('Users').get();
    final userdata =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userdata;
  }
}
