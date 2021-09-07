import 'package:book_club_ref/models/user.dart';
import 'package:book_club_ref/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CurrentUser extends ChangeNotifier {
  late OurUser _currentUser = OurUser();
  OurUser? get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      User _firebaseUser = _auth.currentUser!;
      _currentUser.userId = _firebaseUser.uid;
      _currentUser.email = _firebaseUser.email!;
      _currentUser = await OurDataBase().getUserInfo(_currentUser.userId!);
      _currentUser.pseudo = _currentUser.pseudo;
      _currentUser.groupId = _currentUser.groupId;

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      _currentUser = OurUser();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String pseudo) async {
    String retVal = "error";
    OurUser _user = OurUser();

    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.userId = _authResult.user!.uid;
      _user.email = _authResult.user!.email;
      _user.pseudo = pseudo;
      String _returnString = await OurDataBase().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          retVal = "$email has alread been registered.";
        }
      }
    }
    return retVal;
  }

  Future<bool> loginUser(String email, String password) async {
    bool retValue = false;

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_authResult.user != null) {
        _currentUser.userId = _authResult.user!.uid;
        _currentUser.email = _authResult.user!.email!;
        retValue = true;
      }
    } catch (e) {
      print(e);
    }

    return retValue;
  }
}
