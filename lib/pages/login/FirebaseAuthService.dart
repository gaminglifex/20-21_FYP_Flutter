/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/AppRoutes.dart';

class FirebaseAuthentication {
  static FirebaseAuth _fireAuth = FirebaseAuth.instance;

/*   CustUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return CustUser(
      uid: user.uid,
      email: user.email,
      username: user.displayName,
    );
  } */

/*   
  Stream get authStateChanges {
    return _fireAuth.authStateChanges().map(_userFromFirebase);
  } */

  static Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential authResult = await _fireAuth.signInWithCredential(
          EmailAuthProvider.credential(email: email, password: email));
      Navigator.of(context).pushNamed(AppRoutes.homePage);
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

  static Future<void> createUserWithEmailAndPassword(String username,
      String email, String password, BuildContext context) async {
    final UserCredential authResult = await _fireAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    try {
      UserCredential userCredential = await _fireAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'password': password,
      });
      Navigator.of(context).pushNamed(AppRoutes.homePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    // return _userFromFirebase(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _fireAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return _fireAuth.signOut();
  }

  void dispose() {}
}
 */
