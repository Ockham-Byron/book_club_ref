import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/editScreens/editUser.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/bookSection.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class ProfileManage extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  final BookModel currentBook;
  ProfileManage(
      {Key? key,
      required this.currentUser,
      required this.currentGroup,
      required this.currentBook})
      : super(key: key);

  @override
  _ProfileManageState createState() => _ProfileManageState();
}

class _ProfileManageState extends State<ProfileManage> {
  TextEditingController _pseudoInput = TextEditingController();
  TextEditingController _mailInput = TextEditingController();
  TextEditingController _pictureUrlInput = TextEditingController();

  void _signOut(BuildContext context) async {
    String _returnedString = await Auth().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurRoot(),
        ),
        (route) => false,
      );
    }
  }

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  String getUserPseudo() {
    String userPseudo;
    if (widget.currentUser.pseudo == null) {
      userPseudo = "personne";
    } else {
      userPseudo = widget.currentUser.pseudo!;
    }
    return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
  }

  void _resetPassword(String email) async {
    try {
      String _returnString = await Auth().sendPasswordResetEmail(email);
    } catch (e) {
      print(e);
    }
  }

  void _deleteUser(String userId, String groupId, BuildContext context) async {
    try {
      String _returnString = await Auth().deleteUser();

      if (_returnString == "success") {
        DBFuture().deleteUser(userId, groupId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Pour supprimer votre compte, vous devez d'abord vous reconnecter pour nous assurer que quelqu'un d'autre ne vous joue pas des tours")));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildPopupDialogDeleteUser(
      BuildContext context, String userId, String groupId) {
    return new AlertDialog(
      title: Text("Avez-vous perdu la tête ??"),
      content: Text(
          "Mais bon si vous confirmez que vous souhaitez supprimer votre compte, vous êtes libre..."),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            _deleteUser(userId, groupId, context);
            Navigator.of(context).pop();
          },
          child: const Text('Je pars'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Finalement je reste'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          widget.currentUser.pictureUrl,
          showInitialTextAbovePicture: false,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
          initialsText: Text(
            widget.currentUser.pseudo![0].toUpperCase(),
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: false,
        );
      }
    }

    int getUserReadBooks() {
      int readBooks;
      if (widget.currentUser.readBooks != null) {
        readBooks = widget.currentUser.readBooks!.length;
      } else {
        readBooks = 0;
      }
      return readBooks;
    }

    int getUserReadPages() {
      int readPages;
      if (widget.currentUser.readPages != null) {
        readPages = widget.currentUser.readPages!;
      } else {
        readPages = 0;
      }
      return readPages;
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.93,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.83,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          getUserPseudo(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditUser(
                                    currentGroup: widget.currentGroup,
                                    currentUser: widget.currentUser)));
                          },
                          child: Text(
                            "MODIFIER",
                            style: TextStyle(color: Colors.red[300]),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "LIVRES LUS",
                                    style: kTitleStyle,
                                  ),
                                  Text(
                                    "PAGES LUES",
                                    style: kTitleStyle,
                                  ),
                                  // Text(
                                  //   "FAVORIS",
                                  //   style: kTitleStyle,
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    getUserReadBooks().toString(),
                                    style: kSubtitleStyle,
                                  ),
                                  Text(
                                    getUserReadPages().toString(),
                                    style: kSubtitleStyle,
                                  ),
                                  // Text(
                                  //   "47",
                                  //   style: kSubtitleStyle,
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Continuer de lire",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.start,
                        ),
                        Expanded(
                          child: BookSection(
                              groupId: widget.currentGroup.id!,
                              groupName: widget.currentGroup.name!,
                              currentGroup: widget.currentGroup,
                              currentUser: widget.currentUser),
                        ),

                        // BookSection(
                        //     currentGroup: widget.currentGroup,
                        //     currentUser: widget.currentUser,
                        //     currentBook: widget.currentBook,
                        //     heading: "Continuer de lire"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber[50]),
                child: ClipRect(
                  child: displayCircularAvatar(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
