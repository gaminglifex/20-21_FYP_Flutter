import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fyp_uiprototype/pages/screens/MapsClass.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  GoogleMapController _controller;

  List<Marker> allMarkers = [];

  PageController _pageController;

  int prevPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Shops.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.shopName),
          draggable: false,
          infoWindow: InfoWindow(title: element.shopName, snippet: element.address),
          position: element.locationCoords));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _ShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 150.0,
                    width: 275.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                                  image:
                                      DecorationImage(image: NetworkImage(Shops[index].thumbNail), fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    Shops[index].shopName,
                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    Shops[index].address,
                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    Shops[index].description,
                                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nearby'),
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(22.298596, 114.174291), zoom: 14.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: Shops.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ShopList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: Shops[_pageController.page.toInt()].locationCoords, zoom: 16.0, bearing: 0.0, tilt: 0.0)));
  }
}
