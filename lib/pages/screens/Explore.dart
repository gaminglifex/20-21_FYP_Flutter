import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/common_widget/dataController.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // final CollectionReference _restaurantRef =
  //     FirebaseFirestore.instance.collection('restaurant');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("BigDeal"),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black),
                  ],
                  //TODO: image
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Recommended',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 400.0,
              height: 300.0,
              child: GetBuilder<DataController>(
                init: DataController(),
                builder: (value) {
                  return FutureBuilder(
                    future: value.getData('restaurant'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                          ),
                        );
                      } else {
                        return new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  ProductPage(
                                      restaurantId:
                                          snapshot.data[index].data()['id'],
                                      restaurantName:
                                          snapshot.data[index].data()['name'],
                                      restaurantAddress: snapshot.data[index]
                                          .data()['address'],
                                      latitude: snapshot.data[index]
                                          .data()['location']
                                          .latitude,
                                      longitude: snapshot.data[index]
                                          .data()['location']
                                          .longitude,
                                      gmap: snapshot.data[index].data()['gmap'],
                                      image:
                                          snapshot.data[index].data()['image']),
                                  transition: Transition.leftToRightWithFade,
                                  arguments: snapshot.data[index],
                                );
                                print(snapshot.data[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(snapshot
                                                    .data[index]
                                                    .data()['image']))),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 200.0),
                                          child: Text(
                                            snapshot.data[index].data()['name'],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  String searchHint = 'Find your deals here';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Test01'),
        ),
        ListTile(
          title: Text('Try01'),
        ),
        ListTile(
          title: Text('Test01'),
        ),
        ListTile(
          title: Text('Test01'),
        ),
        ListTile(
          title: Text('Test01'),
        ),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }
}
