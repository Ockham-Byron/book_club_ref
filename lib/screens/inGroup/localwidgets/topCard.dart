import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/review/addareview.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  late AuthModel _authModel;
  bool _doneWithBook = true;
  BookModel? _currentBook;
  late GroupModel _currentGroup;
  late UserModel _pickingUser = UserModel();
  late UserModel _currentUser;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authModel = Provider.of<AuthModel>(context);
    _currentGroup = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    //_currentGroup = await DBFuture().getGroup(_currentUser.groupId!);
    _pickingUser = await DBFuture()
        .getUser(_currentGroup.members![_currentGroup.indexPickingBook!]);
    isUserDoneWithBook();
    if (_currentGroup.currentBookId != null) {
      _currentBook = await DBFuture()
          .getCurrentBook(_currentGroup.id!, _currentGroup.currentBookId!);
    }
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

  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: _currentGroup,
          bookId: _currentGroup.currentBookId!,
        ),
      ),
    );
  }

  String _displayCurrentBookTitle() {
    String currentBookTitle;

    if (_currentBook!.title != null) {
      currentBookTitle = _currentBook!.title!;
    } else {
      currentBookTitle = "pas de livre choisi";
    }
    return currentBookTitle;
  }

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (_currentBook!.cover == null) {
      currentBookCoverUrl =
          "https://www.fly-academy.fr/wp-content/themes/Flyacademy/images/no-img.svg";
    } else {
      currentBookCoverUrl = _currentBook!.cover!;
    }

    return currentBookCoverUrl;
  }

  String _displayRemainingDays() {
    String currentBookDue;
    var today = DateTime.now();

    if (_currentBook!.id != null) {
      var _currentBookDue = _currentBook!.dateCompleted;

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
    if (_currentBook!.title == "en attente") {
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
                    onPressed: () => _goToAddBook(),
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
                    // var _currentBookTitle =
                    //     _currentBook!.title ?? "pas de livre choisi";
                    // var today = DateTime.now();
                    // var _currentBookDue = _currentBook!.dateCompleted;
                    // if (_currentBookDue == null) {
                    //   _currentBookDue = Timestamp.now();
                    // }

                    // var _remainingDays =
                    //     _currentBookDue.toDate().difference(today);
                    // String _displayRemainingDays() {
                    //   String retVal;
                    //   if (_currentBookDue == Timestamp.now()) {
                    //     retVal = "pas de rdv fixé";
                    //   } else {
                    //     if (_remainingDays.isNegative) {
                    //       retVal = "le rdv a déjà eu lieu";
                    //     } else {
                    //       retVal = "Rdv pour échanger dans " +
                    //           _remainingDays.inDays.toString() +
                    //           " jours";
                    //     }
                    //   }

                    //   return retVal;
                    // }

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

  void _goToAddBook() {
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

  @override
  Widget build(BuildContext context) {
    //_currentGroup = Provider.of<GroupModel>(context);
    return _displayCurrentBookInfo();
  }
}
