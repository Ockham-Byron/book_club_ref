import 'package:book_club_ref/screens/login/localwidgets/loginform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).canvasColor));
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ),
                OurLoginForm()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
