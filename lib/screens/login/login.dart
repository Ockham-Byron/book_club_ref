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
                LoginForm(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
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
    );
  }
}
