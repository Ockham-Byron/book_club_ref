import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  final GroupModel currentGroup;
  const MemberCard({Key? key, required this.user, required this.currentGroup})
      : super(key: key);

  bool withProfilePicture() {
    if (user.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  String getUserPseudo() {
    String userPseudo;
    if (user.pseudo == null) {
      userPseudo = "personne";
    } else {
      userPseudo = user.pseudo!;
    }
    return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
  }

  int getUserReadBooks() {
    int readBooks;
    if (user.readBooks != null) {
      readBooks = user.readBooks!.length;
    } else {
      readBooks = 0;
    }
    return readBooks;
  }

  int getnbOfGroupBooks() {
    int nbOfGroupBooks;
    if (currentGroup.nbOfBooks != null) {
      nbOfGroupBooks = currentGroup.nbOfBooks!;
    } else {
      nbOfGroupBooks = 0;
    }
    return nbOfGroupBooks;
  }

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    Color _foregroundColor =
        _randomColor.randomColor(colorBrightness: ColorBrightness.dark);

    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          user.pictureUrl,
          showInitialTextAbovePicture: false,
          radius: 50,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: _foregroundColor,
          initialsText: Text(
            getUserPseudo()[0].toUpperCase(),
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: true,
        );
      }
    }

    return Container(
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: displayCircularAvatar(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getUserPseudo(),
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Theme.of(context).focusColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Livres lus : ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    ),
                    Text(
                      getUserReadBooks().toString(),
                      style: TextStyle(
                          color: Theme.of(context).focusColor, fontSize: 15),
                    ),
                    Text(
                      " / ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    ),
                    Text(
                      getnbOfGroupBooks().toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
