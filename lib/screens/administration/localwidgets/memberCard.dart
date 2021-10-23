import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  const MemberCard({Key? key, required this.user}) : super(key: key);

  bool withProfilePicture() {
    if (user.pictureUrl ==
        "https://digitalpainting.school/static/img/default_avatar.png") {
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
    return userPseudo;
  }

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          user.pictureUrl,
          showInitialTextAbovePicture: false,
          radius: 50,
        );
      } else {
        return CircularProfileAvatar(
          user.pictureUrl,
          foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: displayCircularAvatar(),
          ),
          Column(
            children: [
              Text(getUserPseudo()),
            ],
          ),
        ],
      ),
    );
  }
}
