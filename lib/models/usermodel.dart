import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// class UserModel {
//   final String email;
//   final String uid;
//   final String photourl;
//   final String mobilenum;
//   final String fname;
//   final String lname;
//   const UserModel({
//     required this.fname,
//     required this.lname,
//     required this.mobilenum,
//     required this.uid,
//     required this.photourl,
//     required this.email,
//   });

//   static UserModel fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;

//     return UserModel(
//         uid: snapshot["uid"],
//         email: snapshot["email"],
//         photourl: snapshot["photoUrl"],
//         mobilenum: snapshot["mobilenum"],
//         fname: snapshot['fname'],
//         lname: snapshot['lname']);
//   }

//   Map<String, dynamic> toJson() => {
//         "uid": uid,
//         "email": email,
//         "photoUrl": photourl,
//         'fname': fname,
//         'lname': lname,
//         'mobilenum': mobilenum
//       };
// }

class UserModel {
  final String? id;
  final String fname;
  final String lname;
  final String pass;
  final String phone;
  final String? photourl;
  final String email;
  const UserModel(
      {this.id,
      required this.email,
      this.photourl,
      required this.fname,
      required this.lname,
      required this.pass,
      required this.phone});

  toJson() {
    return {
      'First Name': fname,
      'last name': lname,
      'Email': email,
      'Password': pass,
      'Phone': phone,
      'photo ': photourl
    };
  }

  //map for fecthing users from firestore
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data['Email'],
        fname: data['First Name'],
        lname: data['last name'],
        pass: data['pass'],
        phone: data['Phone']);
  }
}
