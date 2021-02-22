import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:fyp_uiprototype/common_widget/dataController.dart';
//import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';
import 'package:fyp_uiprototype/pages/screens/PriceTracker.dart';
import 'package:fyp_uiprototype/pages/screens/Wishlist.dart';
import 'package:fyp_uiprototype/pages/screens/Testing.dart';

class Tools extends StatefulWidget {
  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> with TickerProviderStateMixin {
  final userId = currentUserId();
  bool flag = false;
  List<dynamic> arrList = [];
  // ignore: non_constant_identifier_names
  TabController _NestedTabController;
  var arrData;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _NestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  dispose() {
    super.dispose();
    _NestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Tools'),
        bottom: TabBar(
          controller: _NestedTabController,
          indicatorColor: Colors.teal,
          indicatorWeight: 6.0,
          isScrollable: false,
          tabs: [
            Tab(
              child: Container(
                child: Text('Wishlist'),
              ),
            ),
            Tab(
              child: Container(
                child: Text('Price Tracker'),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _NestedTabController,
        children: [
          Center(
            child: Wishlist(),
          ),
          Center(
            //child: LineChartSample3(),
            child: PriceTracker(),
          ),
        ],
      ),
    );
  }
}
