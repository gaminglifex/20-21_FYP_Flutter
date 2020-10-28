import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/login/Login.dart';
import 'package:fyp_uiprototype/pages/login/Register.dart';
import 'package:fyp_uiprototype/pages/screens/BottomNav.dart';

class AppRoutes {
  AppRoutes._();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-register';
  static const String homePage = '/BottomNav-main';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => Login(),
      authRegister: (context) => Register(),
      homePage: (context) => BottomNav(),
    };
  }
}
