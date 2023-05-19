// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:com.example.wheel_of_life/models/colorpalletemodel.dart';
import 'package:com.example.wheel_of_life/models/sketch.dart';
import 'package:com.example.wheel_of_life/models/sketchmodel.dart';
import 'package:com.example.wheel_of_life/my.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/detailmandela.dart';
import 'package:com.example.wheel_of_life/view/library/coloringlibrary.dart';
import 'package:com.example.wheel_of_life/view/settings/settingsscreen.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/animal.dart';

class MyLibrary extends StatefulWidget {
  MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> selectedImages = {};
  int check = 0;

  void getInfo() async {
    var collection = FirebaseFirestore.instance.collection('Payment Details');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      print("ok");
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        selectedImages = data?["Images"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getInfo());
      check++;
    }
    return Scaffold(
      backgroundColor: appbg,
      appBar: AppBar(
        title: Text(
          "Library",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 1 / 10,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => SettingsScreen());
              },
              child: Icon(
                Icons.settings,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
        backgroundColor: appbg,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1 / 13,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gd2, gd1],
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get All Pictures!",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Try Premium",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Purchased Mandelas",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PurchasedMandelas(
                                        selectedImages:
                                            selectedImages.values.toList(),
                                      )));
                        },
                        child: Text(
                          "View More...",
                          style: TextStyle(
                              fontSize: 18,
                              color: gd2,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 5,
                  child: ListView.builder(
                      itemCount: selectedImages.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                                selectedImages.values.toList()[index]));
                      }),
                ),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}

class PurchasedMandelas extends StatelessWidget {
  final List<dynamic> selectedImages;

  const PurchasedMandelas({
    super.key,
    required this.selectedImages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Purchased Mandelas",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 1 / 10,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => SettingsScreen());
              },
              child: Icon(
                Icons.settings,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
        backgroundColor: appbg,
        elevation: 0,
      ),
      backgroundColor: appbg,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1 / 13,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gd2, gd1],
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get All Pictures!",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Try Premium",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 30,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  itemCount: selectedImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DrawingBoard(
                                          sketch: SketchModel(
                                              selectedImages[index]),
                                          colorPallet:
                                              MyColorPallet("example", [
                                            Colors.pink.value,
                                            Colors.black87.value,
                                            Colors.yellow.value,
                                            Colors.red.value,
                                            Colors.amberAccent.value,
                                            Colors.purple.value,
                                            Colors.green.value,
                                            Colors.red.value,
                                            Colors.amberAccent.value,
                                            Colors.purple.value,
                                            Colors.green.value,
                                          ]),
                                        )),
                              );
                            },
                            child: Image.asset(selectedImages[index])));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
