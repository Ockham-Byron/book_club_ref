import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProfileManage extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  ProfileManage(
      {Key? key, required this.currentUser, required this.currentGroup})
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

  void _editUserPseudo(
      String pseudo, String userId, BuildContext context) async {
    try {
      String _returnString = await DBFuture().editUserPseudo(userId, pseudo);
      if (_returnString == "success") {
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
    } catch (e) {
      print(e);
    }
  }

  void _editUserMail(String email, String userId, BuildContext context) async {
    try {
      String _returnString = await Auth().resetEmail(email);

      if (_returnString == "success") {
        DBFuture().editUserMail(userId, email);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
    } catch (e) {
      print(e);
    }
  }

  void _editUsePicture(
      String pictureUrl, String userId, BuildContext context) async {
    try {
      String _returnString =
          await DBFuture().editUserPicture(userId, pictureUrl);

      if (_returnString == "success") {
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
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

  Widget _buildPopupDialogPseudo(BuildContext context, String userId) {
    return new AlertDialog(
      title: Text("Changer de pseudo"),
      content: TextField(
        controller: _pseudoInput,
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            _editUserPseudo(_pseudoInput.text, userId, context);
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogEmail(BuildContext context, String userId) {
    return new AlertDialog(
      title: Text("Changer de courriel"),
      content: TextField(
        controller: _mailInput,
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            _editUserMail(_mailInput.text, userId, context);
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogPicture(BuildContext context, String userId) {
    return new AlertDialog(
      title: Text("Changer de tête"),
      content: TextField(
        controller: _pictureUrlInput,
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            _editUsePicture(_pictureUrlInput.text, userId, context);
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogDeleteUser(
      BuildContext context, String userId, String groupId) {
    return new AlertDialog(
      title: Text("Avez-vous perdu la tête ??"),
      content: Text(
          "Mais bon si vous confirmez que vous souhitez supprimer votre compte, vous êtes libre..."),
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
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 350,
              ),
              Positioned(
                  top: 0,
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
                                      builder: (context) {
                                        return _buildPopupDialogPseudo(
                                            context, widget.currentUser.uid!);
                                      });
                                })
                          ],
                        )
                      ],
                    ),
                  )),
              Positioned(
                top: 90,
                left: 200,
                height: 40,
                child: MaterialButton(
                  color: Theme.of(context).focusColor,
                  shape: CircleBorder(),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return _buildPopupDialogPicture(
                              context, widget.currentUser.uid!);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                //left: 60,
                width: 350,
                height: 100,
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
                              height: 20,
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
                      VerticalDivider(
                          thickness: 5, color: Theme.of(context).focusColor),
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
                              height: 20,
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
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.currentUser.email!,
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
                    builder: (BuildContext context) => _buildPopupDialogEmail(
                        context, widget.currentUser.uid!),
                  );
                },
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () => _resetPassword(widget.currentUser.email!),
              child: Text("Modifier mot de passe")),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () => _signOut(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.outbond_rounded,
                  color: Colors.white,
                ),
                Text("Déconnecter"),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialogDeleteUser(
                    context, widget.currentUser.uid!, widget.currentGroup.id!),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.follow_the_signs,
                  color: Colors.white,
                ),
                Text(
                  "Supprimer mon compte",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
