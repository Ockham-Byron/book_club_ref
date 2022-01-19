import 'dart:ui';

import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  const EditUser({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String? initialPseudo;
  String? initialMail;
  String? initialPassword;
  String? initialProfilePicture;

  @override
  void initState() {
    initialPseudo = widget.currentUser.pseudo;
    initialMail = widget.currentUser.email;
    initialPassword = widget.currentUser.password;
    initialProfilePicture = widget.currentUser.pictureUrl;

    _userPseudoInput.text = initialPseudo!;
    _userMailInput.text = initialMail!;
    _userPasswordInput.text = initialPassword!;
    _userProfileInput.text = initialProfilePicture!;

    super.initState();
  }

  TextEditingController _userPseudoInput = TextEditingController();
  TextEditingController _userMailInput = TextEditingController();
  TextEditingController _userPasswordInput = TextEditingController();
  TextEditingController _userProfileInput = TextEditingController();

  void _editUser(
    String userId,
    String userPseudo,
    String userMail,
    String userPassword,
    String userProfilePicture,
  ) async {
    String _returnString;

    _returnString = await DBFuture().editUser(
        userId: userId,
        userPseudo: userPseudo,
        userMail: userMail,
        userPassword: userPassword,
        userPicture: userProfilePicture);

    if (_returnString == "success") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => OurRoot()));
    }
  }

  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              height: 550,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userPseudoInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.book,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Pseudo",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _userMailInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.face,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Courriel",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _userPasswordInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.format_list_numbered,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Mot de passe",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _userProfileInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.auto_stories,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Url de votre photo de profil",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _editUser(
                            widget.currentUser.uid!,
                            _userPseudoInput.text,
                            _userMailInput.text,
                            _userPasswordInput.text,
                            _userProfileInput.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Modifier".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
