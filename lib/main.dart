import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/AppRoutes.dart';
// import 'package:fyp_uiprototype/pages/login/Landing.dart';
import 'package:fyp_uiprototype/pages/Home.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototype',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: AppRoutes.define(),
      home: Home(),
    );
  }
}
