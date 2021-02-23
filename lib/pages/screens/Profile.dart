import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        signOut(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
