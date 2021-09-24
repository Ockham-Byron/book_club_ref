import 'package:book_club_ref/screens/signup/localwidgets/signupform.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 550,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                OurSignUpForm(),
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
    );
  }
}
