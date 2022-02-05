import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/editScreens/editUser.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/bookSection.dart';
import 'package:collection/collection.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class ProfileManage extends StatefulWidget {
  final UserModel currentUser;
  final AuthModel authModel;
  final GroupModel currentGroup;
  final BookModel currentBook;
  ProfileManage(
      {Key? key,
      required this.currentUser,
      required this.currentGroup,
      required this.currentBook,
      required this.authModel})
      : super(key: key);

  @override
  _ProfileManageState createState() => _ProfileManageState();
}

class _ProfileManageState extends State<ProfileManage> {
  late int nbOfReadPages = 0;
  List<BookModel> readBooks = [];
  List<int> readBooksPages = [];

  @override
  void initState() {
    super.initState();
    nbOfReadPages = 0;

    _countReadPages().whenComplete(() {
      setState(() {});
    });
  }

  Future _countReadPages() async {
    for (String bookId in widget.currentUser.readBooks!) {
      readBooks.add(await DBFuture().getBook(bookId, widget.currentGroup.id!));
    }
    for (BookModel book in readBooks) {
      readBooksPages.add(book.length!);
      print(readBooksPages);
    }

    nbOfReadPages = readBooksPages.sum;
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 1000,
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "LIVRES LUS",
                                  style: kTitleStyle,
                                ),
                                Text(
                                  "PAGES LUES",
                                  style: kTitleStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  getUserReadBooks().toString(),
                                  style: kSubtitleStyle,
                                ),
                                Text(
                                  nbOfReadPages.toString(),
                                  style: kSubtitleStyle,
                                ),
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
                      Container(
                        child: BookSection(
                          groupId: widget.currentGroup.id!,
                          groupName: widget.currentGroup.name!,
                          currentGroup: widget.currentGroup,
                          currentUser: widget.currentUser,
                          authModel: widget.authModel,
                          sectionCategory: "continuer",
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Favoris",
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        child: BookSection(
                          groupId: widget.currentGroup.id!,
                          groupName: widget.currentGroup.name!,
                          currentGroup: widget.currentGroup,
                          currentUser: widget.currentUser,
                          authModel: widget.authModel,
                          sectionCategory: "favoris",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber[50]),
                child: ClipRect(
                  child: displayCircularAvatar(),
                ),
              ))
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
