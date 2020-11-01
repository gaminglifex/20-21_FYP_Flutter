import 'package:flutter/material.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Nearby'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Nearby'),
      ),
    );
  }
}
