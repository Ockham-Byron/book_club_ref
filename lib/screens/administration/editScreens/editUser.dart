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

  String? initialProfilePicture;

  @override
  void initState() {
    initialPseudo = widget.currentUser.pseudo;
    initialMail = widget.currentUser.email;

    initialProfilePicture = widget.currentUser.pictureUrl;

    _userPseudoInput.text = initialPseudo!;
    _userMailInput.text = initialMail!;

    _userProfileInput.text = initialProfilePicture!;

    super.initState();
  }

  TextEditingController _userPseudoInput = TextEditingController();
  TextEditingController _userMailInput = TextEditingController();
  TextEditingController _userPasswordInput = TextEditingController();
  TextEditingController _userProfileInput = TextEditingController();

  void _editUserProfile(
    String userId,
    String userPseudo,
    String userProfilePicture,
  ) async {
    String _returnString;

    _returnString = await DBFuture().editUserProfile(
        userId: userId,
        userPseudo: userPseudo,
        userPicture: userProfilePicture);

    if (_returnString == "success") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => OurRoot()));
    }
  }

  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            flexibleSpace: Column(
              children: [
                TabBar(
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "PROFIL",
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "CONNEXION",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      height: 260,
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
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelText: "Pseudo",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
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
                                  Icons.camera,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelText: "Url de votre photo de profil",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  primary: Theme.of(context).primaryColor),
                              onPressed: () {
                                _editUserProfile(
                                    widget.currentUser.uid!,
                                    _userPseudoInput.text,
                                    _userProfileInput.text);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Modifier".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
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
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      height: 260,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: Column(
                          children: [
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
                                  Icons.alternate_email,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelText: "Courriel",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
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
                                  Icons.lock_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelText: "Mot de passe",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  primary: Theme.of(context).primaryColor),
                              onPressed: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Modifier".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
