import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/common_widget/alert_dialog.dart';

final FirebaseAuth _fireAuth = FirebaseAuth.instance;
final _currentUser = _fireAuth.currentUser;
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//  CustUser _userFromFirebase(User user) {
//   if (user == null) {
//     return null;
//   }
//   return CustUser(
//     uid: user.uid,
//     email: user.email,
//     username: user.displayName,
//   );
//

Stream<User> get authStateChanges {
  return _fireAuth.authStateChanges();
}

String currentUserId() {
  return _currentUser.uid;
}

Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    // ignore: unused_local_variable
    final UserCredential authResult =
        await _fireAuth.signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    if (authStateChanges == null) {
      print('authState is null');
      return null;
    } else {
      // return BottomNav();
      AlertDialogBuilder.loadingBuilder(context);
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed('/');
      });
      // Navigator.of(context).pushNamed(AppRoutes.homePage);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print(e);
  }
}

/* Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    final UserCredential authResult = await _fireAuth
        .signInWithEmailAndPassword(email: email, password: password);
    _fireAuth.authStateChanges().listen((User user) {
      if (user != null) {
        print('GOOOOOOOd');
        return BottomNav();
      } else {
        print('GGWP');
      }
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print(e);
  }
} */

Future<void> createUserWithEmailAndPassword(
    String username, String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential = await _fireAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    await _fireStore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'username': username,
      'email': email,
      'password': password,
    });
    if (authStateChanges == null) {
      print('authState is null');
      return null;
    } else {
      // return BottomNav();
      Get.offAllNamed('/');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> sendPasswordResetEmail(String email) async {
  await _fireAuth.sendPasswordResetEmail(email: email);
}

Future<void> signOut(BuildContext context) async {
  try {
    await _fireAuth.signOut();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Get.offAllNamed('/landingPage');
        print('Navigated');
      } else {
        print('GG');
      }
    });
    print('Success');
  } catch (e) {
    print(e);
  }
}

Future<void> addtoWishlist(String userId, String storeId) async {
  // final DocumentReference _checkfield =
  //     _fireStore.collection('user').doc(_currentUser.uid);
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  if (_snapfield.data()['wishlist'] == null) {
    _fireStore.collection('users').doc(_currentUser.uid).set({
      'wishlist': [storeId]
    }, SetOptions(merge: true));
    print('it is null!');
  } else if (_snapfield.data()['wishlist'] != null) {
    _fireStore.collection('users').doc(_currentUser.uid).update({
      'wishlist': FieldValue.arrayUnion([storeId]),
    });
    print('it is not null!');
  }
  print("The is the store Id! $storeId");
}

Future<void> deletefromWishlist(String userId, String storeId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  for (var i in _snapfield.data()['wishlist']) {
    if (i == storeId) {
      _fireStore.collection('users').doc(_currentUser.uid).update({
        'wishlist': FieldValue.arrayRemove([i]),
      });
    }
  }
  // _snapfield.data()['wishlist'].forEach((store) {
  //   print(store);
  //   if (store == storeId) {
  //     _fireStore.collection('users').doc(_currentUser.uid).update({
  //       'wishlist': FieldValue.arrayRemove([store]),
  //     });
  //   }
  // });
  print("The is the store Id! $storeId");
}

Future<dynamic> productCheckWishlist(String userId, String storeId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  bool flag = true;
  // final arrData = _snapfield.data()['wishlist'];
  // return (arrData);
  if (_snapfield.data()['wishlist'] == null || _snapfield.data()['wishlist'].isEmpty) {
    flag = false;
  } else if (!_snapfield.data()['wishlist'].isEmpty) {
    for (var i in _snapfield.data()['wishlist']) {
      if (i == storeId) {
        flag = true;
        break;
      } else if (i != storeId) {
        flag = false;
      }
    }
  }
  // for (var i in _snapfield.data()['wishlist']) {
  //   print("This is shit $i");
  //   // if (i == storeId) {
  //   //   flag = true;
  //   // } else if (i != storeId) {
  //   //   flag = false;
  //   // }
  // }
  return flag;
  // _snapfield.data()['wishlist'].forEach((store) {
  //   print(store);
  //   if (store == storeId) {
  //     _fireStore.collection('users').doc(_currentUser.uid).update({
  //       'wishlist': FieldValue.arrayRemove([store]),
  //     });
  //   }
  // });
}

Future<dynamic> userCheckWishlist(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  bool flag = true;
  // final arrData = _snapfield.data()['wishlist'];
  // return (arrData);
  if (_snapfield.data()['wishlist'] == null || _snapfield.data()['wishlist'].isEmpty) {
    flag = false;
  } else if (!_snapfield.data()['wishlist'].isEmpty) {
    flag = true;
  }
  return flag;
}

Future<dynamic> getWishlist(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  final arrData = _snapfield.data()['wishlist'];
  return arrData;
}

Future<dynamic> userCheckRecommendation(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('recommender').doc(_currentUser.uid).get();
  bool flag = true;
  // final arrData = _snapfield.data()['wishlist'];
  // return (arrData);
  if (_snapfield.data()['storeid'] == null || _snapfield.data()['storeid'].isEmpty) {
    flag = false;
  } else if (!_snapfield.data()['storeid'].isEmpty) {
    flag = true;
  }
  return flag;
}

Future<dynamic> getRecommendation(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('recommender').doc(_currentUser.uid).get();
  final arrData = _snapfield.data()['storeid'];
  return arrData;
}

Future<void> addtoPriceTracker(String userId, String storeId) async {
  // final DocumentReference _checkfield =
  //     _fireStore.collection('user').doc(_currentUser.uid);
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  if (_snapfield.data()['pricetracker'] == null) {
    _fireStore.collection('users').doc(_currentUser.uid).set({
      'pricetracker': [storeId]
    }, SetOptions(merge: true));
    print('it is null!');
  } else if (_snapfield.data()['pricetracker'] != null) {
    _fireStore.collection('users').doc(_currentUser.uid).update({
      'pricetracker': FieldValue.arrayUnion([storeId]),
    });
    print('it is not null!');
  }
  print("The is the store Id! $storeId");
}

Future<void> deletefromPriceTracker(String userId, String storeId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  for (var i in _snapfield.data()['pricetracker']) {
    if (i == storeId) {
      _fireStore.collection('users').doc(_currentUser.uid).update({
        'pricetracker': FieldValue.arrayRemove([i]),
      });
    }
  }
  // _snapfield.data()['wishlist'].forEach((store) {
  //   print(store);
  //   if (store == storeId) {
  //     _fireStore.collection('users').doc(_currentUser.uid).update({
  //       'wishlist': FieldValue.arrayRemove([store]),
  //     });
  //   }
  // });
  print("The is the store Id! $storeId");
}

Future<dynamic> productCheckPriceTracker(String userId, String storeId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  bool flag = true;
  // final arrData = _snapfield.data()['wishlist'];
  // return (arrData);
  if (_snapfield.data()['pricetracker'] == null || _snapfield.data()['pricetracker'].isEmpty) {
    flag = false;
  } else if (!_snapfield.data()['pricetracker'].isEmpty) {
    for (var i in _snapfield.data()['pricetracker']) {
      if (i == storeId) {
        flag = true;
        break;
      } else if (i != storeId) {
        flag = false;
      }
    }
  }
  // for (var i in _snapfield.data()['wishlist']) {
  //   print("This is shit $i");
  //   // if (i == storeId) {
  //   //   flag = true;
  //   // } else if (i != storeId) {
  //   //   flag = false;
  //   // }
  // }
  return flag;
  // _snapfield.data()['wishlist'].forEach((store) {
  //   print(store);
  //   if (store == storeId) {
  //     _fireStore.collection('users').doc(_currentUser.uid).update({
  //       'wishlist': FieldValue.arrayRemove([store]),
  //     });
  //   }
  // });
}

Future<dynamic> userCheckPriceTracker(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  bool flag = true;
  // final arrData = _snapfield.data()['wishlist'];
  // return (arrData);
  if (_snapfield.data()['pricetracker'] == null || _snapfield.data()['pricetracker'].isEmpty) {
    flag = false;
  } else if (!_snapfield.data()['pricetracker'].isEmpty) {
    flag = true;
  }
  return flag;
}

Future<dynamic> getPriceTracker(String userId) async {
  final DocumentSnapshot _snapfield = await _fireStore.collection('users').doc(_currentUser.uid).get();
  final arrData = _snapfield.data()['pricetracker'];
  return arrData;
}

Future<void> updateViews(String storeId) async {
  // final DocumentReference _checkfield =
  //     _fireStore.collection('user').doc(_currentUser.uid);
  final _snapfield = await _fireStore.collection('stores').doc(storeId).get();
  if (_snapfield.data()['views'] == null) {
    _fireStore.collection('stores').doc(storeId).set({'views': '1'}, SetOptions(merge: true));
    print('it is null!');
  } else if (_snapfield.data()['views'] != null) {
    var temp = _snapfield.data()['views'];
    _fireStore.collection('stores').doc(storeId).update({
      'views': (int.parse(temp) + 1).toString(),
    });
    print('it is not null!');
  }
  print("The is the store Id! $storeId");
}

Future<void> checkAndupdateRating(String userId, String storeId, String ratingMark) async {
  // final DocumentReference _checkfield =
  //     _fireStore.collection('user').doc(_currentUser.uid);
  final _snapfield = await _fireStore.collection('stores').doc(storeId).get();
  DocumentSnapshot _snapuser = await _fireStore.collection('users').doc(_currentUser.uid).get();
  if (_snapuser.data()['ratingMap'] == null) {
    _fireStore.collection('users').doc(_currentUser.uid).set({
      'ratingMap': [
        {'id': storeId, 'rating': ratingMark}
      ]
    }, SetOptions(merge: true));
  } else if (_snapuser.data()['ratingMap'] != null) {
    bool flag = false;
    for (var i = 0; i < _snapuser.data()['ratingMap'].length; i++) {
      if (_snapuser.data()['ratingMap'][i]['id'] == storeId) {
        flag = true;
      }
    }
    if (flag != true) {
      _fireStore.collection('users').doc(_currentUser.uid).update(
        {
          'ratingMap': FieldValue.arrayUnion([
            {'id': storeId, 'rating': ratingMark}
          ]),
        },
      );
    } else {
      AlertDialogBuilder.showSnackbar('Message', 'You can only rate once');
    }
  }

  if (_snapfield.data()['rating'] == null) {
    _fireStore.collection('stores').doc(storeId).set({'rating': '0'}, SetOptions(merge: true));
  }

  if (_snapfield.data()['ratingtotal'] == null && _snapfield.data()['ratingPpl'] == null) {
    _fireStore.collection('stores').doc(storeId).set({'ratingtotal': ratingMark}, SetOptions(merge: true));
    _fireStore.collection('stores').doc(storeId).set({'ratingPpl': '1'}, SetOptions(merge: true));
    _fireStore.collection('stores').doc(storeId).update({
      'rating': ratingMark,
    });
    print('it is null!');
  } else if (_snapfield.data()['ratingtotal'] != null && _snapfield.data()['ratingPpl'] != null) {
    var tempTotal = _snapfield.data()['ratingtotal'];
    var tempPpl = _snapfield.data()['ratingPpl'];
    var ratingTotal = double.parse(tempTotal) + double.parse(ratingMark);
    var totalPpl = double.parse(tempPpl) + 1;
    var tempRating = ratingTotal / totalPpl;
    _fireStore.collection('stores').doc(storeId).update({
      'rating': tempRating.toString(),
      'ratingtotal': ratingTotal.toString(),
      'ratingPpl': totalPpl.toString(),
    });
    print('it is not null!');
  }
  print("The is the store Id! $storeId");
}

Future<bool> checkRating(String userId, String storeId) async {
  bool flag = false;
  DocumentSnapshot _snapuser = await _fireStore.collection('users').doc(_currentUser.uid).get();
  if (_snapuser.data()['ratingMap'] != null) {
    for (var i = 0; i < _snapuser.data()['ratingMap'].length; i++) {
      if (_snapuser.data()['ratingMap'][i]['id'] == storeId) {
        flag = true;
      }
    }
  }
  return flag;
}

Future<String> retrieveRating(String userId, String storeId) async {
  String rating = '';
  DocumentSnapshot _snapuser = await _fireStore.collection('users').doc(_currentUser.uid).get();
  if (_snapuser.data()['ratingMap'] != null) {
    for (var i = 0; i < _snapuser.data()['ratingMap'].length; i++) {
      if (_snapuser.data()['ratingMap'][i]['id'] == storeId) {
        rating = _snapuser.data()['ratingMap'][i]['rating'];
        break;
      }
    }
  }
  return rating;
}

void dispose() {}
