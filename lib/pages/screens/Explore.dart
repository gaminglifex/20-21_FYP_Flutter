import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/common_widget/dataController.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // final CollectionReference _restaurantRef =
  //     FirebaseFirestore.instance.collection('restaurant');
  final List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Banner4.jpg?alt=media&token=ed575438-209d-4d0b-96dc-be882f5405d5',
    'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Banner3.png?alt=media&token=2a8315ea-dc43-408b-9350-58a0001dd0c4',
    'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Banner2.jpg?alt=media&token=3cfe1a91-a6f7-46a2-b595-4e4da5ff279d',
    'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Banner.jpg?alt=media&token=6e1c217e-234e-4515-bbff-67cfa922e52b',
  ];
  List<dynamic> arrList = [];
  var arrData;
  final userId = currentUserId();
  bool flag = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void checkAndget() async {
      await userCheckRecommendation(userId).then((value) {
        if (value == true) {
          setState(() {
            flag = true;
          });
          getRecommendation(userId).then((value) {
            arrData = value;
            print("This is init $arrData");
          });
        } else if (value == false) {
          setState(() {
            flag = false;
          });
        }
      });
    }

    checkAndget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("BIG DEAL"),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              //showSearch(context: context, delegate: SearchBar());
              Get.toNamed('/Search');
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
                  color: Colors.white.withOpacity(0),
                  borderRadius: BorderRadius.circular(10.0),

                  //TODO: image
                  /*
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Banner.jpg?alt=media&token=6e1c217e-234e-4515-bbff-67cfa922e52b"),
                  ),
                  */
                ),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    pageViewKey: PageStorageKey<String>('carousel_slider'),
                  ),
                  items: imgList
                      .map(
                        (item) => Container(
                          width: double.infinity,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(item, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Editor\'s Choice',
                style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 400.0,
              height: 220.0,
              child: GetBuilder<DataController>(
                init: DataController(),
                builder: (value) {
                  return FutureBuilder(
                    future: value.getData('recommend_editorchoice'),
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
                                updateViews(snapshot.data[index].data()['id']);
                                Get.to(
                                  () => ProductPage(
                                    storesId: snapshot.data[index].data()['id'],
                                    storesName: snapshot.data[index].data()['name'],
                                    storesAddress: snapshot.data[index].data()['address'],
                                    latitude: snapshot.data[index].data()['location'].latitude,
                                    longitude: snapshot.data[index].data()['location'].longitude,
                                    gmap: snapshot.data[index].data()['gmap'],
                                    image: snapshot.data[index].data()['image'],
                                    link: snapshot.data[index].data()['link'],
                                    source: snapshot.data[index].data()['source'],
                                    rating: snapshot.data[index].data()['rating'],
                                  ),
                                  transition: Transition.leftToRightWithFade,
                                  arguments: snapshot.data[index],
                                );
                                print(snapshot.data[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(snapshot.data[index].data()['image']))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: 200.0),
                                          child: Text(
                                            snapshot.data[index].data()['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: 200.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '@' + snapshot.data[index].data()['source'],
                                              ),
                                              RatingBar.builder(
                                                initialRating: double.parse(snapshot.data[index].data()['rating']),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 16.0,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            ],
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Recommended for you',
                style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 400.0,
              height: 220.0,
              child: GetBuilder<DataController>(
                init: DataController(),
                builder: (value) {
                  return FutureBuilder(
                    future: value.getData('stores'),
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
                          itemCount: arrData.length,
                          itemBuilder: (BuildContext context, int index) {
                            for (var i = 0; i < snapshot.data.length; i++) {
                              for (var k = 0; k < arrData.length; k++) {
                                if (arrData[k] == snapshot.data[i].reference.id) {
                                  arrList.add(i);
                                }
                              }
                            }
                            return GestureDetector(
                              onTap: () {
                                updateViews(snapshot.data[index].data()['id']);
                                Get.to(
                                  () => ProductPage(
                                    storesId: snapshot.data[arrList[index]].data()['id'],
                                    storesName: snapshot.data[arrList[index]].data()['name'],
                                    storesAddress: snapshot.data[arrList[index]].data()['address'],
                                    latitude: snapshot.data[arrList[index]].data()['location'].latitude,
                                    longitude: snapshot.data[arrList[index]].data()['location'].longitude,
                                    gmap: snapshot.data[arrList[index]].data()['gmap'],
                                    image: snapshot.data[arrList[index]].data()['image'],
                                    link: snapshot.data[arrList[index]].data()['link'],
                                    source: snapshot.data[arrList[index]].data()['source'],
                                    rating: snapshot.data[arrList[index]].data()['rating'],
                                  ),
                                  transition: Transition.leftToRightWithFade,
                                  arguments: snapshot.data[arrList[index]],
                                );
                                print(snapshot.data[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(snapshot.data[arrList[index]].data()['image']))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: 200.0),
                                          child: Text(
                                            snapshot.data[arrList[index]].data()['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: 200.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '@' + snapshot.data[arrList[index]].data()['source'],
                                              ),
                                              RatingBar.builder(
                                                initialRating:
                                                    double.parse(snapshot.data[arrList[index]].data()['rating']),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 16.0,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            ],
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
            ),
          ],
        ),
      ),
    );
  }
}
/*
class SearchBar extends SearchDelegate<String> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

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
*/