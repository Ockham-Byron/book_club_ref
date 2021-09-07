import 'package:book_club_ref/screens/signup/localwidgets/signupform.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 450,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: OurSignUpForm()),
      ),
    );
  }
}
