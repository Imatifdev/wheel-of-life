// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:com.example.wheel_of_life/methods/authmodels.dart';
import 'package:com.example.wheel_of_life/view/profile/profileview.dart';

import '../models/sketchmodel.dart';
import 'colorpannel/viewmandelas.dart';
import '../widgets/create.dart';
import 'createpannel/drawpage.dart';
import 'library/mylibrary.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pgindex = 0;
  void selindex(int index) {
    setState(() {});
    pgindex = index;
  }

  final List<Widget> pages = [
    ViewMandelas(),
    DrawingPage(),
    MyLibrary(),
    ProfileView(),
  ];
  List<int> listofpages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedFontSize: 14,
            selectedItemColor: Colors.black,
            selectedFontSize: 16,
            selectedLabelStyle: TextStyle(color: Colors.black),
            iconSize: 30,
            onTap: selindex,
            currentIndex: pgindex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.color_lens,
                    color: Colors.grey,
                  ),
                  label: "fill Color"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.create,
                    color: Colors.grey,
                  ),
                  label: "Create"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard,
                  ),
                  label: "My Library"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  label: "Edit Profile")
            ]),
        body: pages[pgindex]);
  }
}
