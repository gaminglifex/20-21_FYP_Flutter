import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs;
  }

  // Future queryData(String queryString) async {
  //   return FirebaseFirestore.instance
  //       .collection('restaurant')
  //       .where('type', isEqualTo: queryString)
  //       .get();
  // }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('stores')
        .orderBy('name')
        .startAt([queryString]).endAt([queryString + '\uf8ff']).get();
  }

  // Future getDocId(String collection) async {
  //   DocumentReference refid =
  //       FirebaseFirestore.instance.collection(collection).doc();
  //   DocumentSnapshot snapid = await refid.get();
  //   var snapped = snapid.reference.id;
  //   return snapped;
  // }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
