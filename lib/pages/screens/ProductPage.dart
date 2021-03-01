// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/screens/GoogleMap.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';
import 'package:fyp_uiprototype/common_widget/alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double latitude;
  final double longitude;
  final String gmap;
  final String image;
  final String link;
  final String source;
  final String rating;
  ProductPage({
    this.restaurantId,
    this.restaurantName,
    this.restaurantAddress,
    this.latitude,
    this.longitude,
    this.gmap,
    this.image,
    this.link,
    this.source,
    this.rating,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final CollectionReference _restaurantRef =
  //     FirebaseFirestore.instance.collection("restaurant");
  bool _wishlistState = false;
  bool _pricetrackerState = false;
  bool _ignoreState = false;
  String getRating = '0';
  final userId = currentUserId();

  void _launchUrl(String launchUrl) async {
    //String temp = launchUrl.replaceAll(RegExp(',\s*'), '+');
    final webUrl = launchUrl;
    if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
      throw 'Could not open url';
    }
  }

  void check3() async {
    _ignoreState = await checkRating(userId, widget.restaurantId);
    if (_ignoreState == true) {
      getRating = await retrieveRating(userId, widget.restaurantId);
    } else if (_ignoreState != true) {
      getRating = '0';
    }
  }

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

    void check2() async {
      await productCheckPriceTracker(userId, widget.restaurantId).then((value) {
        print(value);
        if (value == true) {
          setState(() {
            _pricetrackerState = true;
          });
        } else if (value == false) {
          _pricetrackerState = false;
        }
      });
    }

    check();
    check2();
    check3();
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.restaurantName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse(widget.rating),
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
                                  ignoreGestures: true,
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ButtonTheme(
                              minWidth: 30.0,
                              height: 30.0,
                              child: MaterialButton(
                                onPressed: () {
                                  Share.share("${widget.restaurantName}\n${widget.restaurantAddress}");
                                },
                                child: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ButtonTheme(
                              minWidth: 30.0,
                              height: 30.0,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_wishlistState != true) {
                                    addtoWishlist(userId, widget.restaurantId).whenComplete(
                                        () => AlertDialogBuilder.showSnackbar('Message', 'Added to Wishlist'));
                                  } else if (_wishlistState == true) {
                                    deletefromWishlist(userId, widget.restaurantId).whenComplete(
                                        () => AlertDialogBuilder.showSnackbar('Message', 'Deleted from Wishlist'));
                                  }
                                  setState(() {
                                    _wishlistState = !_wishlistState;
                                  });
                                },
                                child: Icon(
                                  _wishlistState ? Icons.turned_in : Icons.bookmark_border,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ButtonTheme(
                              minWidth: 30.0,
                              height: 30.0,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_pricetrackerState != true) {
                                    addtoPriceTracker(userId, widget.restaurantId).whenComplete(
                                        () => AlertDialogBuilder.showSnackbar('Message', 'Added to PriceTracker'));
                                  } else if (_pricetrackerState == true) {
                                    deletefromPriceTracker(userId, widget.restaurantId).whenComplete(
                                        () => AlertDialogBuilder.showSnackbar('Message', 'Deleted from Wishlist'));
                                  }
                                  setState(() {
                                    _pricetrackerState = !_pricetrackerState;
                                  });
                                },
                                child: Icon(
                                  _pricetrackerState ? Icons.analytics : Icons.analytics_outlined,
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
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(getRating),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30.0,
                              ignoreGestures: _ignoreState,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                checkAndupdateRating(userId, widget.restaurantId, rating.toString())
                                    .whenComplete(() => check3());
                              },
                            ),
                          ],
                        ),
                        Container(
                          child: _ignoreState ? Text('Thanks for your rating!') : Text('Leave your Rating here!'),
                        ),
                      ],
                    ),
                  ),
                ],
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
                          () => MapSample(
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
                      leading: Icon(Icons.web),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text('Direct to Original Page'),
                      onTap: () {
                        _launchUrl(widget.link);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: 'Data Retrieved From' + ' '),
                          TextSpan(text: widget.source, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
