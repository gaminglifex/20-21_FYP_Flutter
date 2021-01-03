import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fyp_uiprototype/common_widget/alert_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double latitude;
  final double longitude;
  final String gmap;
  MapSample(
      {this.restaurantId,
      this.restaurantName,
      this.restaurantAddress,
      this.latitude,
      this.longitude,
      this.gmap});
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // final CollectionReference _restaurantRef =
  //     FirebaseFirestore.instance.collection('restaurant');
  final Set<Marker> _markers = {};
  GoogleMapController _mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          consumeTapEvents: false,
          markerId: MarkerId(widget.restaurantId),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: "${widget.restaurantName}",
            snippet: "${widget.restaurantAddress}",
          ),
        ),
      );
    });
  }

  void showInfo() async {
    await Future.delayed(Duration(seconds: 1));
    _mapController.showMarkerInfoWindow(_markers.elementAt(0).markerId);
  }

  void _launchUrl(String launchUrl) async {
    String temp = launchUrl.replaceAll(RegExp(',\s*'), '+');
    print("$temp");
    final mapUrl = "https://www.google.com/maps/search/?api=1&query=$temp";
    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      throw 'Could not open url';
    }
  }

  // _snackBar(BuildContext context) async {
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Copied to Clipboard'),
  //       action: SnackBarAction(
  //         label: 'Undo',
  //         onPressed: () {},
  //       ),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  // }

  // _goToGoogleMap() {
  //   print('Clicked');
  // }

  @override
  void initState() {
    super.initState();
    showInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(widget.restaurantName),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 17.50,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
          ),
          Positioned(
            right: 0.0,
            bottom: 100.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _launchUrl(widget.restaurantAddress);
                      },
                      child: Icon(Icons.map),
                      backgroundColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      height: 100,
                      child: Card(
                        elevation: 8.0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.restaurantAddress),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                            ),
                            MaterialButton(
                              onPressed: () {
                                // Clipboard.setData(ClipboardData(
                                //         text: widget.restaurantAddress))
                                //     .then((result) {
                                //   _scaffoldKey.currentState.showSnackBar(
                                //     SnackBar(
                                //       content: Text('Copied to Clipboard'),
                                //       duration: Duration(seconds: 1),
                                //     ),
                                //   );
                                // });
                                Clipboard.setData(ClipboardData(
                                        text: widget.restaurantAddress))
                                    .then((result) {
                                  AlertDialogBuilder.showSnackbar(
                                      'Message', 'Added to Wishlist');
                                });
                              },
                              child: Icon(Icons.content_copy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
