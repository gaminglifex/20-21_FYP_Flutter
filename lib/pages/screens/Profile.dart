import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';
import 'package:fyp_uiprototype/common_widget/AppRoutes.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

Future<void> _logOut(BuildContext context) async {
  await Firebase.initializeApp();
  try {
    await FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Navigator.of(context).pushNamed(AppRoutes.landingPage);
        print('Navigated');
      } else {
        print('GG');
      }
    });
    print('Success');
  } catch (e) {
    print(e);
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Logout'),
            onPressed: () async {
              _logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
