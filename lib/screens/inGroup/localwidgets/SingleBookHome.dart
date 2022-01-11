import 'dart:ui';

import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';

import 'package:book_club_ref/screens/review/addareview.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/appDrawer.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:provider/provider.dart';

class SingleBookHome extends StatefulWidget {
  final GroupModel currentGroup;
  final String groupId;
  final AuthModel authModel;
  final UserModel currentUser;
  const SingleBookHome(
      {Key? key,
      required this.currentGroup,
      required this.groupId,
      required this.authModel,
      required this.currentUser})
      : super(key: key);

  @override
  _SingleBookHomeState createState() => _SingleBookHomeState();
}

class _SingleBookHomeState extends State<SingleBookHome> {
  late BookModel _currentBook = BookModel();
  late UserModel _pickingUser = UserModel();

  bool _doneWithBook = true;

  @override
  void initState() {
    super.initState();

    _initBook().whenComplete(() {
      setState(() {});
    });
  }

  Future _initBook() async {
    _currentBook = await DBFuture()
        .getCurrentBook(widget.groupId, widget.currentGroup.currentBookId!);

    if (widget.currentGroup.currentBookId != null) {
      _currentBook = await DBFuture().getCurrentBook(
          widget.currentGroup.id!, widget.currentGroup.currentBookId!);
    }

    _pickingUser = await DBFuture().getUser(
        widget.currentGroup.members![widget.currentGroup.indexPickingBook!]);

    //check if the user is done with book
    if (widget.currentGroup.currentBookId != null) {
      if (await DBFuture().isUserDoneWithBook(widget.currentGroup.id!,
          widget.currentGroup.currentBookId!, widget.authModel.uid!)) {
        _doneWithBook = true;
      } else {
        _doneWithBook = false;
      }
    }
  }

  String _displayGroupName() {
    if (widget.currentGroup.name != null) {
      return widget.currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

  String _displayBookTitle() {
    if (_currentBook.title != null) {
      return _currentBook.title!;
    } else {
      return "pas de titre défini";
    }
  }

  String _displayRemainingDays() {
    String currentBookDue;
    var today = DateTime.now();

    if (_currentBook.id != null) {
      var _currentBookDue = _currentBook.dateCompleted;

      var _remainingDays = _currentBookDue!.toDate().difference(today);
      if (_currentBookDue == Timestamp.now()) {
        currentBookDue = "pas de rdv fixé";
      } else if (_remainingDays.isNegative) {
        currentBookDue = "le rdv a déjà eu lieu";
      } else if (_remainingDays.inDays == 1) {
        currentBookDue = "rdv demain !";
      } else if (_remainingDays.inDays == 0) {
        currentBookDue = "rdv aujourd'hui !";
      } else {
        currentBookDue = "Rdv pour échanger dans " +
            _remainingDays.inDays.toString() +
            " jours";
      }
    } else {
      currentBookDue = "pas de rdv établi";
    }
    return currentBookDue;
  }

  String _displayDueDate() {
    var dueDate = _currentBook.dateCompleted!.toDate();
    String dueDay = dueDate.day.toString();
    String dueMonth = dueDate.month.toString();

    return dueDay + " / " + dueMonth;
  }

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (_currentBook.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = _currentBook.cover!;
    }

    return currentBookCoverUrl;
  }

  Widget _displayCurrentBookInfo2() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 160),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Consumer<GroupModel>(
                builder: (BuildContext context, value, Widget? child) {
                  return ShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            _displayBookTitle(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white38,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _displayRemainingDays(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                              onPressed: _doneWithBook ? null : _goToReview,
                              child: Text("Livre terminé !"),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          child: Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(_currentBookCoverUrl())),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayCurrentBookInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 210,
          width: 70,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(_currentBookCoverUrl()))),
        ),
        Column(
          children: [
            Text(_displayBookTitle()),
            Text(_currentBook.author!),
            Text(_currentBook.length!.toString() + "pages"),
            ElevatedButton(
              onPressed: _doneWithBook ? null : _goToReview,
              child: Text("Livre terminé !"),
            ),
          ],
        )
      ],
    );
  }

  void _changePickingUser() {
    DBFuture().changePicker(widget.currentGroup.id!);
    setState(() async {
      _pickingUser = await DBFuture().getUser(
          widget.currentGroup.members![widget.currentGroup.indexPickingBook!]);
    });
  }

  Widget _displayNextBookInfo() {
    if (_pickingUser.uid == widget.currentUser.uid) {
      return Column(
        children: [
          Text(
            "C'est à ton tour de choisir le prochain livre",
            style: TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                onPressed: () => _goToAddNextBook(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.add),
                ),
              ),
              TextButton(
                  onPressed: () => _changePickingUser(),
                  child: Text(
                    "Je préfère passer mon tour",
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ))
            ],
          ),
        ],
      );
    } else {
      String _pickingUserPseudo = _pickingUser.pseudo ?? "pas encore déterminé";
      return Column(
        children: [
          Text(
            "Prochain livre à choisir par",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _pickingUserPseudo,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).focusColor,
            ),
          ),
        ],
      );
    }
  }

  void _goToAddNextBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: false,
          onError: false,
          currentGroup: widget.currentGroup,
          //currentUser: _pickingUser,
        ),
      ),
    );
  }

  void _goToHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHistory(
          groupId: widget.groupId,
          groupName: widget.currentGroup.name!,
          currentGroup: widget.currentGroup,
          currentUser: widget.currentUser,
        ),
      ),
    );
  }

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: widget.currentGroup,
          bookId: widget.currentGroup.currentBookId!,
        ),
      ),
    );
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

  Widget build(BuildContext context) {
    // _getFutures();
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
          showInitialTextAbovePicture: true,
        );
      }
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
                left: 10,
                right: 10,
                top: 50,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Builder(
                        builder: (context) => GestureDetector(
                          child: displayCircularAvatar(),
                          onTap: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: 200.0,
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
                  SizedBox(
                    width: 20,
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
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 50,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 50,
                      ),
                      child: Column(
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
                            widget.currentUser.pseudo!,
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
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Prochain livre à lire pour le ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _displayDueDate(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                              ),
                              _displayCurrentBookInfo()
                            ],
                          )
                        ],
                      ),
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
