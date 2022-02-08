import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/groupManageRef.dart';

import 'package:book_club_ref/screens/administration/profileManage.dart';
import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';
import 'package:book_club_ref/screens/inGroup/localwidgets/SingleBookHome.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel currentBook;
  final AuthModel authModel;

  const AppDrawer(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.currentBook,
      required this.authModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToHome() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleBookHome(
                currentGroup: currentGroup,
                groupId: currentBook.id!,
                currentUser: currentUser,
                authModel: authModel,
              )));
    }

    void _goToGroupManage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GroupManageRef(
                currentGroup: currentGroup,
                currentUser: currentUser,
                currentBook: currentBook,
                authModel: authModel,
              )));
    }

    void _goToProfileManage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileManage(
                currentUser: currentUser,
                currentGroup: currentGroup,
                currentBook: currentBook,
                authModel: authModel,
              )));
    }

    void _goToBooksHistory() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookHistory(
              groupId: currentGroup.id!,
              groupName: currentGroup.name!,
              currentGroup: currentGroup,
              currentUser: currentUser,
              currentBook: currentBook,
              authModel: authModel)));
    }

    bool withProfilePicture() {
      if (currentUser.pictureUrl == "") {
        return false;
      } else {
        return true;
      }
    }

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

    String getUserPseudo() {
      String userPseudo;
      if (currentUser.pseudo == null) {
        userPseudo = "personne";
      } else {
        userPseudo = currentUser.pseudo!;
      }
      return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
    }

    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.

        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 3, color: Theme.of(context).primaryColor),
              ),
            ),
            child: Row(
              children: [
                displayCircularAvatar(),
                SizedBox(
                  width: 20,
                ),
                Text(
                  getUserPseudo(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                    leading: Icon(
                      Icons.houseboat,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Accueil",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                    onTap: () => _goToHome()),
                ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Profil",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                    onTap: () => _goToProfileManage()),
                ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Groupe",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                  onTap: () => _goToGroupManage(),
                ),
                ListTile(
                  leading: Icon(
                    Icons.auto_stories,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Livres",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                  onTap: () => _goToBooksHistory(),
                ),
                SizedBox(
                  height: 50,
                ),
                Image.network(
                  "https://cdn.pixabay.com/photo/2018/04/24/11/32/book-3346785_1280.png",
                  fit: BoxFit.contain,
                  width: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
