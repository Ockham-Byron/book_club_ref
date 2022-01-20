import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      String email, String password, String pseudo, String pictureUrl) async {
    String retVal = "error";

    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);

      UserModel _user = UserModel(
        uid: _userCredential.user!.uid,
        email: _userCredential.user!.email,
        pseudo: pseudo.trim(),
        pictureUrl: pictureUrl,
        accountCreated: Timestamp.now(),
      );

      String _returnString = await DBFuture().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
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

  // Reset Password
  Future<String> sendPasswordResetEmail(String email) async {
    String retVal = "error";
    try {
      _auth.sendPasswordResetEmail(email: email);
      retVal = "sucess";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  // Reset email
  Future<String> resetEmail(String email) async {
    String retVal = "error";
    try {
      await _auth.currentUser!.updateEmail(email);
      retVal = "success";
    } on PlatformException catch (e) {
      print(e);
      retVal = "exception";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  // Reset password
  Future<String> resetPassword(String password) async {
    String retVal = "error";
    try {
      _auth.currentUser!.updatePassword(password);
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  //Delete User
  Future<String> deleteUser() async {
    String retVal = "error";
    try {
      _auth.currentUser!.delete();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
