import 'dart:ui';

import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:flutter/material.dart';

class GroupWithoutBook extends StatelessWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const GroupWithoutBook(
      {required this.currentGroup,
      required this.currentUser,
      required this.authModel});

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

  String _displayGroupName() {
    if (currentGroup.name != null) {
      return currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

  @override
  Widget build(BuildContext context) {
    void _goToAddBook() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AddBook(
                    onGroupCreation: false,
                    onError: false,
                    currentUser: currentUser,
                    currentGroup: currentGroup,
                  )),
          (route) => false);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 50,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: 300.0,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Text(
                          _displayGroupName(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => _signOut(context),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bonjour",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentUser.pseudo!,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            bottom: 30,
                          ),
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Il n'y a pas encore de livre dans ce groupe ;(",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => _goToAddBook(),
                          child: Text("Ajouter le premier livre"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
