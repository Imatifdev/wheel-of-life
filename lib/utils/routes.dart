import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:com.example.wheel_of_life/view/plans/showmainpage.dart';
import 'package:com.example.wheel_of_life/view/settings/settingsscreen.dart';
import 'package:com.example.wheel_of_life/view/authview/authhome.dart';
import 'package:com.example.wheel_of_life/view/authview/forgotpassword.dart';
import 'package:com.example.wheel_of_life/view/authview/login.dart';
import 'package:com.example.wheel_of_life/view/authview/signup.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/animal.dart';
import 'package:com.example.wheel_of_life/view/dashboard.dart';
import 'package:com.example.wheel_of_life/view/splash.dart';

import '../view/plans/showplans.dart';

appRoutes() => [
      GetPage(
        name: '/splash',
        page: () => SplashScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/authhome',
        page: () => AuthHome(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/settings',
        page: () => SettingsScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/animalMandela',
        page: () => AnimalMandel(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/login',
        page: () => LoginPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/signup',
        page: () => SignupPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/home',
        page: () => Home(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/forgot',
        page: () => ForgitPassword(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/ShowingMainPage',
        page: () => ShowingMainPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/Plans',
        page: () => Plans(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (kDebugMode) {
      print(page?.name);
    }
    return super.onPageCalled(page);
  }
}
