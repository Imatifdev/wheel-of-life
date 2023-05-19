// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/models/sketchmodel.dart';
import 'package:com.example.wheel_of_life/view/settings/settingsscreen.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/animal.dart';

class ViewMandelas extends StatelessWidget {
  const ViewMandelas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbg,
      appBar: AppBar(
        title: Text(
          "Fill Color",
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
            height: MediaQuery.of(context).size.height / 12,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Animal mandela",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AnimalMandel());
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
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => AnimalMandel());
                                },
                                child: ShowGrid(
                                  skectpic: UsersData.users[index],
                                ),
                              ));
                        }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kids Special",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                        itemCount: UsersData.users.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShowGrid(
                                skectpic: UsersData.users[index],
                              ));
                        }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kids Special",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                        itemCount: UsersData.users.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShowGrid(
                                skectpic: UsersData.users[index],
                              ));
                        }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Level up Mandela",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                        itemCount: UsersData.users.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShowGrid(
                                skectpic: UsersData.users[index],
                              ));
                        }),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class ShowGrid extends StatelessWidget {
  final SketchModel skectpic;

  const ShowGrid({super.key, required this.skectpic});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Image(
        fit: BoxFit.contain,
        height: 150,
        width: 150,
        image: AssetImage(skectpic.url),
      ),
    );
  }
}
