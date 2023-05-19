import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/models/sketchmodel.dart';
import 'package:com.example.wheel_of_life/my.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/colorslistpage.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/detailmandela.dart';
import 'package:com.example.wheel_of_life/view/settings/settingsscreen.dart';

import '../../models/colorpalletemodel.dart';
import '../library/coloringlibrary.dart';

class PalletScreen extends StatefulWidget {
  final String sketch;
  static const routeName = "pallet_screen";
  const PalletScreen({
    super.key,
    required this.sketch,
  });

  @override
  State<PalletScreen> createState() => _PalletScreenState();
}

class _PalletScreenState extends State<PalletScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Widget _buildListItem(MyColorPallet pallet) {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () {
        print("Tapped");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DrawingBoard(
                  sketch: SketchModel(widget.sketch),
                  colorPallet: pallet,
                )));
      },
      child: Column(
        children: [
          Text(pallet.pallete_nme),
          Container(
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              itemCount: pallet.mycolors.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Color(pallet.mycolors[index]),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(QuerySnapshot<Object?>? snapshot) {
    if (snapshot!.docs.isEmpty) {
      return const Center(child: Text("No Pallets Yet!"));
    } else {
      return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          final task = MyColorPallet.fromSnapshot(doc);
          return _buildListItem(task);
        },
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Pallets")
                .doc("$userId Pallet")
                .collection("User Pallets")
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return Expanded(child: _buildList(snapshot.data));
            }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbg,
      appBar: AppBar(
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: appbg,
        title: const Text(
          "Select Your Pallete",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SettingsScreen());
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(context)),
          FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ColorsScreen(),
                ));
              },
              label: Text("Create New Pallete"))
        ],
      ),
    );
  }
}
