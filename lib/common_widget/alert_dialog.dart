import 'package:flutter/material.dart';

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
}
