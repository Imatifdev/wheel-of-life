// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:com.example.wheel_of_life/models/storeimage.dart';
import 'package:com.example.wheel_of_life/models/usermodel.dart' as model;
import 'package:com.example.wheel_of_life/view/authview/login.dart';

class FirebaseAuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //data needed to storre in firebase database
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  //signup user
  // Future<String> signupUser({
  //   required String email,
  //   required String fname,
  //   required String lname,
  //   required String mobilenum,
  //   required String pass,
  //   required Uint8List file,
  // }) async {
  //   String res = "Error occuered";
  //   try {
  //     if (email.isNotEmpty ||
  //         pass.isNotEmpty ||
  //         fname.isNotEmpty ||
  //         mobilenum.isNotEmpty ||
  //         lname.isNotEmpty ||
  //         file != null) {
  //       //register user
  //       UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //           email: email, password: pass);
  //       String photourl =
  //           await StorageMethod().uploadImage('profilepics', file);
  //       print(cred.user!.uid);
  //       // mapping our userdata model here
  //       model.UserModel user = model.UserModel(
  //           fname: fname,
  //           lname: lname,
  //           mobilenum: mobilenum,
  //           uid: cred.user!.uid,
  //           photourl: photourl,
  //           email: email);

  //       await _fireStore
  //           .collection('users')
  //           .doc(cred.user!.uid)
  //           .set(user.toJson());
  //     }
  //     String res = "succes";
  //     //store data in data base
  //   } catch (e) {
  //     return e.toString();
  //   }
  //   return res;
  // }
  // //login user

  Future<String> loginuser({required email, required pass}) async {
    String res = "Error occur";
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        res = "Succes";
      }
    } catch (error) {
      error.toString();
      return res;
    }
    return res;
  }
  //forgot password

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent successfully");
    } catch (e) {
      print("Failed to send password reset email: $e");
    }
  }

  //signout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.to(() => LoginPage());
    // You can add additional code here to handle the sign-out process
  }

  //google signin

  // Future<User?> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount!.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   final UserCredential authResult =
  //       await _auth.signInWithCredential(credential);
  //   final User? user = authResult.user;
  //   return user;
  // }

  // Future<void> addUserToFirestore(User user) async {
  //   DocumentReference userRef = _fireStore.collection('users').doc(user.uid);

  //   Map<String, dynamic> userData = {
  //     'name': user.displayName,
  //     'email': user.email,
  //     'photoUrl': user.photoURL,
  //     'phonenum': user.phoneNumber
  //   };

  //   await userRef.set(userData);
  // }

  // Future<model.UserModel> getUserDetails() async {
  //   User? currentUser = _auth.currentUser;

  //   DocumentSnapshot documentSnapshot =
  //       await _fireStore.collection('users').doc(currentUser!.uid).get();

  //   return model.UserModel.fromSnap(documentSnapshot);
  // }

  final GoogleSignIn _googleSignInfun = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignInfun.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
