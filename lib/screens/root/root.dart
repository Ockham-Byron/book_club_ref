import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/screens/home/home.dart';
import 'package:book_club_ref/screens/login/login.dart';
import 'package:book_club_ref/screens/noGroup/nogroup.dart';
import 'package:book_club_ref/screens/splashScreen/splashScreen.dart';
import 'package:book_club_ref/states/currentGroup.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus { unknown, notLoggedIn, notInGroup, inGroup }

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current user, set Authstatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context);

    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.notInGroup;
      });
      print("not in Group");
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
        retVal = Scaffold(body: Center(child: Text("statut inconnu")));
        //retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = Scaffold(body: Center(child: Text("pas connecté")));

        //retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = Scaffold(body: Center(child: Text("pas dans un groupe")));
        //retVal = NoGroup();
        break;
      case AuthStatus.inGroup:
        retVal = Scaffold(body: Center(child: Text("dans un groupe")));
        // retVal = ChangeNotifierProvider(
        //     create: (BuildContext context) => CurrentGroup(),
        //     child: HomeScreen());

        break;
      default:
    }
    return retVal;
  }
}
