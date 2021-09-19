import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:flutter/material.dart';

class PrincipalAppBar extends StatelessWidget {
  const PrincipalAppBar({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    String _returnedString = await Auth().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurRoot(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.outbond_rounded,
            color: Colors.white,
          ),
          onPressed: () => _signOut(context),
        )
      ],
    );
  }
}
