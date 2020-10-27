import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/Home.dart';
import 'package:fyp_uiprototype/pages/login/Starting.dart';
// import 'package:fyp_uiprototype/pages/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${streamSnapshot.error}'),
                  ),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                User user = streamSnapshot.data;
                if (user == null) {
                  // User not logged in
                  return Starting();
                } else {
                  //User logged in
                  return Home();
                }
              }

              return Scaffold(
                body: Center(
                  child: Text('Checking Authentication'),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Initializing App'),
          ),
        );
      },
    );
  }
}
