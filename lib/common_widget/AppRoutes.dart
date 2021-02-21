import 'package:get/get.dart';
import 'package:fyp_uiprototype/pages/login/Landing.dart';
import 'package:fyp_uiprototype/pages/login/Login.dart';
import 'package:fyp_uiprototype/pages/login/Register.dart';
import 'package:fyp_uiprototype/pages/screens/BottomNav.dart';
import 'package:fyp_uiprototype/pages/login/SplashScreen.dart';
import 'package:fyp_uiprototype/common_widget/Search.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/', page: () => BottomNav()),
    GetPage(name: '/authLogin', page: () => Login()),
    GetPage(name: '/authRegister', page: () => Register()),
    GetPage(name: '/landingPage', page: () => LandingPage()),
    GetPage(name: '/Search', page: () => Search()),
    GetPage(
      name: '/SplashScreen',
      page: () => SplashScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 3000),
    ),
  ];
}
