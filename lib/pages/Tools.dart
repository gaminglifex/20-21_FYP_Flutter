import 'package:flutter/material.dart';

class Tools extends StatefulWidget {
  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tools'),
      ),
      body: Center(
        child: Text('Tools'),
      ),
    );
  }
}
