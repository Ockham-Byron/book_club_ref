import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/inGroup/groupHome.dart';
import 'package:book_club_ref/screens/login/login.dart';
import 'package:book_club_ref/screens/noGroup/nogroup.dart';
import 'package:book_club_ref/screens/splashScreen/splashScreen.dart';
import 'package:book_club_ref/services/dbStream.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn }

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String? currentUid;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current user, set Authstatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context);

    if (_authStream.uid != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
      print("loggedIn");
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
      print("not Logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal = Scaffold(
      body: Center(
        child: Text("initial"),
      ),
    );

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = Login();
        break;
      case AuthStatus.loggedIn:
        retVal = StreamProvider<UserModel>.value(
          value: DBStream().getcurrentUser(currentUid!),
          initialData: UserModel(),
          child: LoggedIn(),
        );
        //retVal = InGroup();
        break;

      default:
    }
    return retVal;
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _userStream = Provider.of<UserModel>(context);
    Widget retVal;
    if (_userStream.uid != null) {
      if (_userStream.groupId != null) {
        retVal = StreamProvider<GroupModel>.value(
          value: DBStream().getcurrentGroup(_userStream.groupId!),
          initialData: GroupModel(),
          child: GroupHome(),
        );
      } else {
        retVal = NoGroup();
      }
    } else {
      retVal = OurSplashScreen();
    }
    return retVal;
  }
}
