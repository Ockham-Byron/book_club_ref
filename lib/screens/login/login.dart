import 'dart:ui';

import 'package:book_club_ref/screens/login/localwidgets/loginform.dart';
import 'package:book_club_ref/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).canvasColor));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Image(
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LoginForm(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Première visite ici ? Créez un compte",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).canvasColor,
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
