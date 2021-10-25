import 'package:book_club_ref/models/userModel.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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

  String getUserPseudo() {
    String userPseudo;
    if (currentUser.pseudo == null) {
      userPseudo = "personne";
    } else {
      userPseudo = currentUser.pseudo!;
    }
    return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Modifier'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
      ],
    );
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

    int getUserReadBooks() {
      int readBooks;
      if (currentUser.readBooks != null) {
        readBooks = currentUser.readBooks!.length;
      } else {
        readBooks = 0;
      }
      return readBooks;
    }

    int getUserReadPages() {
      int readPages;
      if (currentUser.readPages != null) {
        readPages = currentUser.readPages!;
      } else {
        readPages = 0;
      }
      return readPages;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getUserPseudo(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          child: Icon(Icons.edit),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
            top: 250,
            //left: 60,
            width: 350,
            height: 250,
            child: Container(
                width: 350,
                height: 100,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Livres lus".toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            getUserReadBooks().toString(),
                            style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: VerticalDivider(
                          thickness: 5, color: Theme.of(context).focusColor),
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Pages lues".toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            getUserReadPages().toString(),
                            style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
