// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/view/authview/login.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/viewmandelas.dart';
import 'package:com.example.wheel_of_life/view/dashboard.dart';
import 'package:com.example.wheel_of_life/view/plans/showplans.dart';

import '../../utils/mycolors.dart';
import '../../widgets/mybutton.dart';
import '../authview/signup.dart';

class ShowingMainPage extends StatelessWidget {
  const ShowingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 200,
              width: double.infinity,
              image: AssetImage('assets/topman.png'),
            ),
            Text(
              "Full Access",
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
            ),
            Text(
              "Get it now",
              style: TextStyle(
                  fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => Home());
              },
              child: Text(
                "Or Continue with a limited version",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Enjoy Coluring 1000+ amazing pictures with any pallete you like , create countless mandlas with no add ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "7 days  free trial and renewl at 2000 ksh on every year.  Cancel anytime atleast 24 hours before renewel  ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyCustomButton(
                width: MediaQuery.of(context).size.width - 70,
                title: "Try free and subscribe anually",
                borderrad: 25,
                onaction: () {
                  Get.to(() => Plans());
                },
                color1: gd2,
                color2: gd1),
            const SizedBox(
              height: 20,
            ),
            MyCustomButton(
                width: MediaQuery.of(context).size.width - 70,
                title: "View Packages",
                borderrad: 25,
                onaction: () {
                  Get.to(() => Plans());
                },
                color1: green,
                color2: green),
          ],
        ),
      ),
    );
  }
}
