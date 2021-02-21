import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/common_widget/dataController.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(snapshotData.docs[index].data()['image']),
            ),
            title: Text(
              snapshotData.docs[index].data()['name'],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              snapshotData.docs[index].data()['type'],
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0),
            ),
            onTap: () {
              Get.to(
                ProductPage(
                  restaurantId: snapshotData.docs[index].data()['id'],
                  restaurantName: snapshotData.docs[index].data()['name'],
                  restaurantAddress: snapshotData.docs[index].data()['address'],
                  latitude:
                      snapshotData.docs[index].data()['location'].latitude,
                  longitude:
                      snapshotData.docs[index].data()['location'].longitude,
                  gmap: snapshotData.docs[index].data()['gmap'],
                  image: snapshotData.docs[index].data()['image'],
                  link: snapshotData.docs[index].data()['link'],
                  source: snapshotData.docs[index].data()['source'],
                  rating: snapshotData.docs[index].data()['rating'],
                ),
                transition: Transition.leftToRightWithFade,
                arguments: snapshotData.docs[index],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          searchController.clear();
        },
      ),
      */
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
              }),
          /*
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                  icon: Icon(Icons.search_outlined),
                  onPressed: () {
                    val.queryData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                        print(snapshotData.docs[0].data());
                      });
                    });
                  });
            },
          )
          */
        ],
        title: TextField(
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Find your deals here.',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          controller: searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            DataController().queryData(searchController.text).then((value) {
              snapshotData = value;
              setState(() {
                isExecuted = true;
                print(snapshotData.docs[0].data());
              });
            });
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: isExecuted
          ? searchedData()
          : Container(
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.black, fontSize: 30.0),
                ),
              ),
            ),
    );
  }
}
