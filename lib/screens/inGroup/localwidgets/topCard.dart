import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
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
  late BookModel _currentBook;
  late GroupModel _currentGroup;

  @override
  void didChangeDependencies() async {
    _authModel = Provider.of<AuthModel>(context);
    _currentGroup = Provider.of<GroupModel>(context);

    isUserDoneWithBook();
    _currentBook = await DBFuture()
        .getCurrentBook(_currentGroup.id!, _currentGroup.currentBookId!);

    super.didChangeDependencies();
  }

  isUserDoneWithBook() async {
    if (await DBFuture().isUserDoneWithBook(
        _currentGroup.id!, _currentGroup.currentBookId!, _authModel.uid!)) {
      _doneWithBook = true;
    } else {
      _doneWithBook = false;
    }
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 160),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainer(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Consumer<GroupModel>(
                  builder: (BuildContext context, value, Widget? child) {
                    var _currentBookTitle =
                        _currentBook.title ?? "pas de livre choisi";
                    var today = DateTime.now();
                    var _currentBookDue = _currentBook.dateCompleted;
                    if (_currentBookDue == null) {
                      _currentBookDue = Timestamp.now();
                    }

                    var _remainingDays =
                        _currentBookDue.toDate().difference(today);
                    String _displayRemainingDays() {
                      String retVal;
                      if (_currentBookDue == Timestamp.now()) {
                        retVal = "pas de rdv fixé";
                      } else {
                        if (_remainingDays.isNegative) {
                          retVal = "le rdv a déjà eu lieu";
                        } else {
                          retVal = "Rdv pour échanger dans " +
                              _remainingDays.inDays.toString() +
                              " jours";
                        }
                      }

                      return retVal;
                    }

                    return Column(
                      children: [
                        Text(
                          _currentBookTitle,
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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          child: Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://www.babelio.com/couv/CVT_Le-Sympathisant_4996.jpg")),
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
