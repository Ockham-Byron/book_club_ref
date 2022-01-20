import 'dart:ui';

import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void _editUserPseudo(
      String pseudo, String userId, BuildContext context) async {
    try {
      String _returnString = await DBFuture().editUserPseudo(userId, pseudo);
      if (_returnString == "success") {
        Fluttertoast.showToast(
            msg:
                "Votre pseudo est modifié ! Changer d'identité est une des vertus de la littérature...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "Ne me demandez pas pourquoi, mais ça n'a pas fonctionné. Il faut parfois accepter l'incertitude...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  void _editUserPicture(String pictureUrl, String userId) async {
    try {
      String _returnString =
          await DBFuture().editUserPicture(userId, pictureUrl);

      if (_returnString == "success") {
        Fluttertoast.showToast(
            msg: "C'est bon vous avez changé de tête !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "Avez_vous l'absolue certitude d'avoir copié collé un format image ?",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  void _editUserMail({required String userId, required String mail}) async {
    try {
      String _returnString = await Auth().resetEmail(mail);
      if (_returnString == "success") {
        DBFuture().editUserMail(userId, mail);
        Fluttertoast.showToast(
            msg:
                "Votre mail est modifié ! Changer d'adresse sans bouger de son canapé, quel confort...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (_returnString == "exception") {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  void _resetPassword(String email) async {
    try {
      String _returnString = await Auth().sendPasswordResetEmail(email);
    } catch (e) {
      print(e);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
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
                            child: Icon(Icons.person)),
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
                            child: Icon(Icons.camera)),
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
                            child: Icon(Icons.mail_outline)),
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
                            child: Icon(Icons.lock)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //Modifier pseudo
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
                      height: 200,
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  primary: Theme.of(context).primaryColor),
                              onPressed: () {
                                _editUserPseudo(_userPseudoInput.text,
                                    widget.currentUser.uid!, context);
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
              //Modifier Picture
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
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: Column(
                          children: [
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
                                _editUserPicture(_userProfileInput.text,
                                    widget.currentUser.uid!);
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
              //Modifier Mail
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
                      height: 250,
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  primary: Theme.of(context).primaryColor),
                              onPressed: () {
                                _editUserMail(
                                  userId: widget.currentUser.uid!,
                                  mail: _userMailInput.text,
                                );
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
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () => _signOut(context),
                                child: Text(
                                  "Se déconnecter".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Modifier Mot de passe
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
                                labelText: "Votre courriel",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                "Vous souhaitez changer de mot de passe ? Vérifiez votre courriel ci-dessus, nous allons y envoyer un lien pour modifier votre mot de passe."),
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
                                _resetPassword(_userMailInput.text);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Envoyer".toUpperCase(),
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
