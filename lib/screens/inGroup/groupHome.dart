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
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key}) : super(key: key);

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  late AuthModel _authModel;
  bool _doneWithBook = true;

  late GroupModel _currentGroup;
  late UserModel _pickingUser = UserModel();
  late UserModel _currentUser;
  BookModel _currentBook = BookModel();

  _getFutures() async {
    if (_currentGroup.id != null) {
      _currentBook = await DBFuture()
          .getCurrentBook(_currentGroup.id!, _currentGroup.currentBookId!);
    }

    int _nbOfMembers = _currentGroup.members!.length;
    int? _actualPicker = _currentGroup.indexPickingBook;
    if (_actualPicker! > (_nbOfMembers - 1)) {
      _pickingUser = await DBFuture()
          .getUser(_currentGroup.members![_currentGroup.indexPickingBook!]);
    } else {
      _pickingUser = await DBFuture().getUser(_currentGroup.members![0]);
    }

    isUserDoneWithBook();
  }

  isUserDoneWithBook() async {
    if (_currentGroup.currentBookId != null) {
      if (await DBFuture().isUserDoneWithBook(
          _currentGroup.id!, _currentGroup.currentBookId!, _authModel.uid!)) {
        _doneWithBook = true;
      } else {
        _doneWithBook = false;
      }
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

  void _goToHistory() async {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHistory(
          groupId: group.id!,
          groupName: group.name!,
        ),
      ),
    );
  }

  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: _currentGroup,
        ),
      ),
    );
  }

  String _displayCurrentBookTitle() {
    String currentBookTitle;

    if (_currentBook.title != null) {
      currentBookTitle = _currentBook.title!;
    } else {
      currentBookTitle = "prochain livre pas encore choisi";
    }
    return currentBookTitle;
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

  Widget _displayCurrentBookInfo() {
    if (_currentBook.title == "en attente") {
      if (_pickingUser.uid == _currentUser.uid) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ShadowContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    "C'est à ton tour de choisir le livre",
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).focusColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    shape: CircleBorder(),
                    onPressed: () => _goToAddInitialBook(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        String _pickingUserPseudo =
            _pickingUser.pseudo ?? "pas encore déterminé";
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ShadowContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    "Prochain livre choisi par",
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
              ),
            ),
          ),
        );
      }
    } else {
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
                              _displayCurrentBookTitle(),
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
                image: DecorationImage(
                    image: NetworkImage(_currentBookCoverUrl())),
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
  }

  void _goToAddInitialBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: false,
          onError: true,
          currentGroup: _currentGroup,
          currentUser: _pickingUser,
        ),
      ),
    );
  }

  Widget _displayNextBookInfo() {
    if (_pickingUser.uid == _currentUser.uid) {
      return Column(
        children: [
          Text(
            "C'est à ton tour de choisir le prochain livre",
            style: TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
          ),
          SizedBox(
            height: 5,
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            shape: CircleBorder(),
            onPressed: () => _goToAddNextBook(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.add),
            ),
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
          currentGroup: _currentGroup,
          currentUser: _pickingUser,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    _authModel = Provider.of<AuthModel>(context);
    _currentGroup = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    _getFutures();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Consumer<GroupModel>(
          builder: (BuildContext context, value, Widget? child) {
            var _currentGroupName = value.name ?? "Groupe sans nom";
            return Text(
              _currentGroupName,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.outbond_rounded,
              color: Colors.white,
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          _displayCurrentBookInfo(),
          SizedBox(
            height: 2,
          ),
          _displayNextBookInfo(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
            child: ElevatedButton(
                onPressed: () => _goToHistory(),
                child: Text("Voir l'historique du club de lecture"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor))),
          ),
        ],
      ),
    );
  }
}
