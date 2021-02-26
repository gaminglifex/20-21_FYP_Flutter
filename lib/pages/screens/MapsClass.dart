import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearShop {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;

  NearShop({this.shopName, this.address, this.description, this.thumbNail, this.locationCoords});
}

final List<NearShop> Shops = [
  NearShop(
      shopName: 'OPPA Korean Restaurant',
      address: 'G/F, Kin Wong Manison,117 Sai Yee Street, Mong Kok',
      description: '',
      locationCoords: LatLng(22.320445, 114.1712922),
      thumbNail:
          'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/OPPA%20Korean%20Restaurant.jpg?alt=media&token=7504063f-dc17-415d-a0d1-3f896b7ca52e'),
  NearShop(
      shopName: 'YoLi',
      address: '1/F, Witty Commercial Building Deli2, 1A-1L Tung Choi Street, Mong Kok',
      description: '',
      locationCoords: LatLng(22.316296, 114.171057),
      thumbNail:
          'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/YoLi.jpg?alt=media&token=126a9fa1-c979-42e3-a9b2-10a0e5e6cb3d'),
  NearShop(
      shopName: 'Pyeong Chang',
      address: '13/F, CTMA Centre, 1 Sai Yeung Choi Street, Mong Kok',
      description: '',
      locationCoords: LatLng(22.3158072, 114.1706004),
      thumbNail:
          'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Pyeong%20Chang.jpg?alt=media&token=6fc2010b-236e-47b3-81c9-b74800fa605a'),
  NearShop(
      shopName: 'Running BBQ',
      address: '9/F, 726 Nathan Road, Mong Kok',
      description: '',
      locationCoords: LatLng(22.3211688, 114.1691628),
      thumbNail:
          'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Running%20BBQ.jpg?alt=media&token=abe7bff8-297d-4a5f-8be1-4c5ca274050b'),
  NearShop(
      shopName: 'Hancham Korean BBQ Restaurant',
      address: '1/F., Winfield Commercial Building, 6-8A Prat Avenue, Tsim Sha Tsui',
      description: '',
      locationCoords: LatLng(22.298596, 114.174291),
      thumbNail:
          'https://firebasestorage.googleapis.com/v0/b/eietest2020.appspot.com/o/Hancham%20Korean%20BBQ%20Restaurant.jpg?alt=media&token=fdaf3854-7e4d-4a6f-b0f1-9699ea76a4ef')
];
