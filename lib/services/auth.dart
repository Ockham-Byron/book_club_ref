import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AuthModel> get user {
    return _auth.authStateChanges().map(
        (User? firebaseUser) => AuthModel.fromFirebaseUser(user: firebaseUser));
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String pseudo) async {
    String retVal = "error";

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // String _returnString = await OurDataBase().createUser(_user);
      // if (_returnString == "success") {
      //   retVal = "success";
      // }
      retVal = "success";
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          retVal = "$email has already been registered.";
        }
      }
    }
    return retVal;
  }

  Future<bool> loginUser(String email, String password) async {
    bool retValue = false;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      retValue = true;
    } catch (e) {
      print(e);
    }

    return retValue;
  }
}
