import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/bookHistory/reviewHistory.dart';
import 'package:book_club_ref/services/dbFuture.dart';
//import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';
//import 'package:book_club_ref/services/dbFuture.dart';

import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final BookModel? book;
  final String? groupId;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const BookCard(
      {Key? key,
      this.book,
      this.groupId,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  void initState() {
    super.initState();

    _initBook().whenComplete(() {
      setState(() {});
    });
  }

  bool _doneWithBook = true;

  Future _initBook() async {
    if (await DBFuture().isUserDoneWithBook(
        widget.currentGroup.id!, widget.book!.id!, widget.currentUser.uid!)) {
      _doneWithBook = true;
    } else {
      _doneWithBook = false;
    }
  }

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (widget.book!.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = widget.book!.cover!;
    }

    return currentBookCoverUrl;
  }

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: widget.groupId!,
          bookId: widget.book!.id!,
          currentGroup: widget.currentGroup,
          currentBook: widget.book!,
          currentUser: widget.currentUser,
          authModel: widget.authModel,
        ),
      ),
    );
  }

  Widget _displayBookCard() {
    if (_doneWithBook == false) {
      return GestureDetector(
        onTap: () => _goToReviewHistory(context),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: Image.network(_currentBookCoverUrl()),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.book!.title ?? "Pas de titre",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            widget.book!.author ?? "Pas d'auteur",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _displayBookCard();
  }
}
