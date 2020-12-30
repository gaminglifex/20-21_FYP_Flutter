import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
    if (await canLaunch(launchUrl)) {
      await launch(launchUrl);
    } else {
      throw 'Could not open url';
    }
  }

  // _goToGoogleMap() {
  //   print('Clicked');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        _launchUrl(widget.gmap);
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
        ],
      ),
    );
  }
}
