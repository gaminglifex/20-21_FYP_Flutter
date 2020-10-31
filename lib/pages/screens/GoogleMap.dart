import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double latitude;
  final double longitude;
  MapSample(
      {this.restaurantId,
      this.restaurantName,
      this.restaurantAddress,
      this.latitude,
      this.longitude});
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
        ],
      ),
    );
  }
}
