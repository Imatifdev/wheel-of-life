// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/models/colorpalletemodel.dart';
import 'package:com.example.wheel_of_life/models/sketch.dart';
import 'package:com.example.wheel_of_life/my.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/detailmandela.dart';

import '../../models/sketchmodel.dart';
import '../createpannel/drawpage.dart';
import '../library/coloringlibrary.dart';
import '../settings/settingsscreen.dart';

class AnimalMandel extends StatelessWidget {
  const AnimalMandel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Animal Mandela",
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  itemCount: 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final show = UsersData.users[index];
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrawingBoard(
                                sketch: show,
                                colorPallet: MyColorPallet("Example", [
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
                              ),
                            ),
                          );
                        },
                        child: ShowGrid(sketchpic: show));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowGrid extends StatelessWidget {
  final SketchModel sketchpic;

  const ShowGrid({super.key, required this.sketchpic});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          fit: BoxFit.cover,
          height: 200,
          width: 200,
          image: AssetImage(sketchpic.url),
        ),
      ),
    );
  }
}
