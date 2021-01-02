// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/screens/GoogleMap.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';

class ProductPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double latitude;
  final double longitude;
  final String gmap;
  final String image;
  ProductPage(
      {this.restaurantId,
      this.restaurantName,
      this.restaurantAddress,
      this.latitude,
      this.longitude,
      this.gmap,
      this.image});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final CollectionReference _restaurantRef =
  //     FirebaseFirestore.instance.collection("restaurant");
  bool _wishlistState = false;
  final userId = currentUserId();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check Wishlist
    void check() async {
      await productCheckWishlist(userId, widget.restaurantId).then((value) {
        print(value);
        if (value == true) {
          setState(() {
            _wishlistState = true;
          });
        } else if (value == false) {
          _wishlistState = false;
        }
      });
    }

    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.restaurantName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ButtonTheme(
                              minWidth: 30.0,
                              height: 30.0,
                              child: MaterialButton(
                                onPressed: () {
                                  Share.share(
                                      "${widget.restaurantName}\n${widget.restaurantAddress}");
                                },
                                child: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ButtonTheme(
                              minWidth: 30.0,
                              height: 30.0,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_wishlistState != true) {
                                    addtoWishlist(userId, widget.restaurantId)
                                        .whenComplete(() => Get.snackbar(
                                              '',
                                              '',
                                              titleText: Text(
                                                'Messages',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              messageText: Text(
                                                'Added to Wishlist',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.grey[300]
                                                  .withOpacity(0.7),
                                              animationDuration:
                                                  Duration(milliseconds: 500),
                                              duration:
                                                  Duration(milliseconds: 1000),
                                            ));
                                  } else if (_wishlistState == true) {
                                    deletefromWishlist(
                                            userId, widget.restaurantId)
                                        .whenComplete(() => Get.snackbar(
                                              '',
                                              '',
                                              titleText: Text(
                                                'Messages',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              messageText: Text(
                                                'Deleted from Wishlist',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.grey[300]
                                                  .withOpacity(0.5),
                                              animationDuration:
                                                  Duration(milliseconds: 500),
                                              duration:
                                                  Duration(milliseconds: 1000),
                                            ));
                                  }
                                  setState(() {
                                    _wishlistState = !_wishlistState;
                                  });
                                },
                                child: Icon(
                                  _wishlistState
                                      ? Icons.turned_in
                                      : Icons.bookmark_border,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Opening Hours'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text('Price'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.call),
                      title: Text('Telephone'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(widget.restaurantAddress),
                      onTap: () {
                        Get.to(
                          MapSample(
                              restaurantId: widget.restaurantId,
                              restaurantName: widget.restaurantName,
                              restaurantAddress: widget.restaurantAddress,
                              latitude: widget.latitude,
                              longitude: widget.longitude,
                              gmap: widget.gmap),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
