import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/common_widget/dataController.dart';
import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';

class Tools extends StatefulWidget {
  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  final userId = currentUserId();
  bool flag = false;
  List<dynamic> arrList = [];
  var arrData;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void checkAndget() async {
      await userCheckWishlist(userId).then((value) {
        if (value == true) {
          setState(() {
            flag = true;
          });
          getWishlist(userId).then((value) {
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

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flag) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Tools'),
          backgroundColor: Colors.white,
        ),
        body: GetBuilder<DataController>(
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
                    scrollDirection: Axis.vertical,
                    itemCount: arrData.length,
                    // ignore: missing_return
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
                          Get.to(
                            ProductPage(
                                restaurantId:
                                    snapshot.data[arrList[index]].data()['id'],
                                restaurantName: snapshot.data[arrList[index]]
                                    .data()['name'],
                                restaurantAddress: snapshot.data[arrList[index]]
                                    .data()['address'],
                                latitude: snapshot.data[arrList[index]]
                                    .data()['location']
                                    .latitude,
                                longitude: snapshot.data[arrList[index]]
                                    .data()['location']
                                    .longitude,
                                gmap: snapshot.data[arrList[index]]
                                    .data()['gmap'],
                                image: snapshot.data[arrList[index]]
                                    .data()['image']),
                            transition: Transition.leftToRightWithFade,
                            arguments: snapshot.data[arrList[index]],
                          );
                        },
                        child: Dismissible(
                          key: Key(snapshot.data[arrList[index]].reference.id),
                          onDismissed: (_) {
                            deletefromWishlist(userId,
                                snapshot.data[arrList[index]].reference.id);
                          },
                          background: deleteBgItem(),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(snapshot
                                                .data[arrList[index]]
                                                .data()['image']))),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 200.0),
                                          child: Text(
                                            snapshot.data[arrList[index]]
                                                .data()['name'],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      // for (var i in arrData) {
                      //   print("$index, this is $i");
                      //   if (snapshot.data[index].reference.id == i) {
                      //     // arrList.add(snapshot.data[index].reference.id);
                      //     print(arrList);
                      //     return GestureDetector(
                      //       onTap: () {
                      //         Get.to(
                      //           ProductPage(
                      //               restaurantId:
                      //                   snapshot.data[index].data()['id'],
                      //               restaurantName:
                      //                   snapshot.data[index].data()['name'],
                      //               restaurantAddress:
                      //                   snapshot.data[index].data()['address'],
                      //               latitude: snapshot.data[index]
                      //                   .data()['location']
                      //                   .latitude,
                      //               longitude: snapshot.data[index]
                      //                   .data()['location']
                      //                   .longitude,
                      //               gmap: snapshot.data[index].data()['gmap'],
                      //               image:
                      //                   snapshot.data[index].data()['image']),
                      //           transition: Transition.leftToRightWithFade,
                      //           arguments: snapshot.data[index],
                      //         );
                      //       },
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Card(
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Container(
                      //                 height: 150.0,
                      //                 width: 150.0,
                      //                 decoration: BoxDecoration(
                      //                     image: DecorationImage(
                      //                         fit: BoxFit.cover,
                      //                         image: NetworkImage(snapshot
                      //                             .data[index]
                      //                             .data()['image']))),
                      //               ),
                      //               Column(
                      //                 children: [
                      //                   Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Container(
                      //                       constraints:
                      //                           BoxConstraints(maxWidth: 200.0),
                      //                       child: Text(
                      //                         snapshot.data[index]
                      //                             .data()['name'],
                      //                         style: TextStyle(
                      //                           color: Colors.black,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   } else {
                      //     print('bad');
                      //   }
                      // }
                      // return Container();
                      // snapshot.data[index].reference.id.forEach((i) {
                      //   if (snapshot.data[index].reference.id == arrData[index]) {
                      //     print('good');
                      //   } else {
                      //     print('bad');
                      //   }
                      // });
                      // print("$index ${snapshot.data[index].reference.id}");
                    },
                  );
                }
              },
            );
          },
        ),
      );
    } else if (!flag) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Tools'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text('The Wishlist is Empty'),
        ),
      );
    }
    return CircularProgressIndicator();
  }
}
