import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:com.example.wheel_of_life/methods/authmodels.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageMethod {
  //instance to store image in database
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//adding image to firebase database
  Future<String> uploadImage(String child, Uint8List file) async {
//ref is used for ADD IMAGE reference
    Reference ref = _storage.ref().child(child).child(_auth.currentUser!.uid);

    UploadTask uploadtask = ref.putData(file);
    TaskSnapshot snap = await uploadtask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}
