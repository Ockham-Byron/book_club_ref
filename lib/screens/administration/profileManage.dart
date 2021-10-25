import 'package:book_club_ref/models/userModel.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileManage extends StatelessWidget {
  final UserModel currentUser;
  const ProfileManage({Key? key, required this.currentUser}) : super(key: key);

  bool withProfilePicture() {
    if (currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          currentUser.pictureUrl,
          showInitialTextAbovePicture: false,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
          initialsText: Text(
            currentUser.pseudo![0].toUpperCase(),
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: false,
        );
      }
    }

    Widget _displayTopCardUserInfo() {
      return Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                color: Theme.of(context).focusColor,
                height: 200,
              ),
              Container(
                child: Text("profilimage"),
              ),
            ],
          ),
          Positioned(
            top: 150,
            child: Container(
              height: 100,
              width: 300,
              color: Colors.white,
              child: Row(
                children: [],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 350,
          ),
          Positioned(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Theme.of(context).focusColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    displayCircularAvatar(),
                    Text(currentUser.pseudo!)
                  ],
                ),
              )),
          Positioned(
            top: 250,
            //left: 60,
            width: 250,
            height: 250,
            child: Container(
                width: 300,
                height: 100,
                color: Colors.white,
                child: Row(
                  children: [],
                )),
          ),
        ],
      ),
    );
  }
}
