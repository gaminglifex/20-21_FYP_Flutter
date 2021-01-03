import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertDialogBuilder {
  final String description;
  AlertDialogBuilder({
    @required this.description,
  });

  static Future<void> alertBuilder(
      String description, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static Future<void> loadingBuilder(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                  ),
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                  ),
                  Text("Loading"),
                ]),
          ),
        );
      },
    );
  }

  static void showSnackbar(String title, String message) {
    return Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[100].withOpacity(1),
      leftBarIndicatorColor: Colors.green,
      snackStyle: SnackStyle.GROUNDED,
      animationDuration: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 1000),
    );
  }
/*   static Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
        )
      });
  } */
}
