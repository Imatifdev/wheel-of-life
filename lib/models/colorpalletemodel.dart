import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyColorPallet {
  final String pallete_nme;
  List mycolors;

  MyColorPallet(this.pallete_nme, this.mycolors);

  factory MyColorPallet.fromSnapshot(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    final Map<String, dynamic> colorMap = map["Pallet Colors"];
    return MyColorPallet(
        map["Pallet Name"] as String, colorMap.values.toList());
  }
}

List palletes = [
  MyColorPallet('Rainbow', [Colors.red, Colors.green, Colors.blue])
];
