import 'package:get/get.dart';
import 'package:fyp_uiprototype/pages/login/Landing.dart';
import 'package:fyp_uiprototype/pages/login/Login.dart';
import 'package:fyp_uiprototype/pages/login/Register.dart';
import 'package:fyp_uiprototype/pages/screens/BottomNav.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/', page: () => BottomNav()),
    GetPage(name: '/authLogin', page: () => Login()),
    GetPage(name: '/authRegister', page: () => Register()),
    GetPage(name: '/landingPage', page: () => LandingPage()),
  ];
}
