import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/common_widget/AppRoutes.dart';
import 'package:fyp_uiprototype/pages/login/Landing.dart';
import 'package:get/get.dart';
// import 'package:fyp_uiprototype/pages/screens/BottomNav.dart';
// import 'package:firebase_core/firebase_core.dart';

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} */

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototype',
      getPages: AppRoutes.pages,
      initialRoute: '/landingPage',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // routes: AppRoutes.define(),
      home: LandingPage(),
    );
  }
}
