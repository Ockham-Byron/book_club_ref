import 'dart:ui';

import 'package:book_club_ref/screens/signup/localwidgets/signupform.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
                height: 600,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SignUpForm(),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Vous avez déjà un compte ? Connectez-vous",
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
                )),
          ),
        ),
      ),
    );
  }
}
