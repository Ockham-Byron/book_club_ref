import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/createGroup/createGroup.dart';
import 'package:book_club_ref/screens/joinGroup/joinGroup.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context);
    void _goToJoin() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JoinGroup(
            userModel: _currentUser,
          ),
        ),
      );
    }

    void _goToCreate() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateGroup(
                userModel: _currentUser,
              )));
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(40, 10, 40, 100),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
          Text(
            "Bienvenue au club",
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                  fontSize: 40, color: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Maintenant, il est temps de rejoindre un club de lecture ou... d'en créer un.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _goToJoin(),
                  child: Text("Rejoindre un club"),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => _goToCreate(),
                    child: Text("Créer un club")),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
