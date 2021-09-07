import 'package:book_club_ref/screens/home/home.dart';
import 'package:book_club_ref/screens/login/login.dart';
import 'package:book_club_ref/screens/noGroup/nogroup.dart';
import 'package:book_club_ref/screens/splashScreen/splashScreen.dart';
import 'package:book_club_ref/states/currentGroup.dart';
import 'package:book_club_ref/states/currentUser.dart';
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

    //get the state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await _currentUser.onStartUp();
    if (returnString == "success") {
      if (_currentUser.getCurrentUser!.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.inGroup;
        });
        print("in group");
        print(_currentUser.getCurrentUser!.pseudo);
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroup;
          print(_currentUser.getCurrentUser!.pseudo);
        });
        print("not in Group");
      }
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
      print("not Logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal = OurLogin();

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = NoGroup();
        break;
      case AuthStatus.inGroup:
        retVal = ChangeNotifierProvider(
            create: (BuildContext context) => CurrentGroup(),
            child: HomeScreen());

        break;
      default:
    }
    return retVal;
  }
}
