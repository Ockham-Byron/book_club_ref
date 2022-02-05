import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/bookHistory/finishedBook.dart';
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
    return GestureDetector(
      onTap: () => _goToReviewHistory(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 150,
        child: Column(
          children: [
            Container(
              width: 100,
              //height: 200,
              child: Image.network(_currentBookCoverUrl()),
            ),
            Text(
              widget.book!.title ?? "Pas de titre",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            Text(
              widget.book!.author ?? "Pas d'auteur",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FinishedBook(
                                finishedBook: widget.book!,
                                currentGroup: widget.currentGroup,
                                currentUser: widget.currentUser,
                                authModel: widget.authModel,
                              )));
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _displayBookCard();
  }
}
