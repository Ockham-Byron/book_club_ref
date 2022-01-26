import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/editScreens/editBook.dart';
//import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';
//import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

import '../reviewHistory.dart';

class EachBook extends StatefulWidget {
  final BookModel? book;
  final String? groupId;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const EachBook(
      {Key? key,
      this.book,
      this.groupId,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  _EachBookState createState() => _EachBookState();
}

class _EachBookState extends State<EachBook> {
  // bool _isFavorited = false;

  // void _toggleFavorite() {
  //   setState(() {
  //     if (_isFavorited = false) {
  //       _isFavorited = true;
  //     } else {
  //       _isFavorited = false;
  //     }
  //   });
  // }

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

  String _nbOfPages() {
    String nbOfPages;

    if (widget.book!.length != null) {
      nbOfPages = widget.book!.length!.toString() + " pages";
    } else {
      nbOfPages = "Nombre de pages inconnu";
    }

    return nbOfPages;
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

  @override
  Widget build(BuildContext context) {
    // Widget _displayFavorite() {
    //   return TextButton.icon(
    //     onPressed: () {
    //       if (widget.currentUser.favoriteBooks!.contains(widget.book!.id)) {
    //         DBFuture().cancelFavoriteBook(
    //             widget.groupId!, widget.book!.id!, widget.currentUser.uid!);
    //         _toggleFavorite();
    //       } else {
    //         DBFuture().favoriteBook(
    //             widget.groupId!, widget.book!.id!, widget.currentUser.uid!);
    //         _toggleFavorite();
    //       }
    //     },
    //     icon: Icon(Icons.favorite,
    //         color: _isFavorited == true
    //             ? Theme.of(context).primaryColor
    //             : Colors.grey),
    //     label: Text(
    //       "Favori",
    //       style: TextStyle(
    //           color: _isFavorited == true
    //               ? Theme.of(context).primaryColor
    //               : Colors.grey),
    //     ),
    //   );
    // }

    return GestureDetector(
      onTap: () => _goToReviewHistory(context),
      child: ShadowContainer(
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(_nbOfPages())
                      ],
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditBook(
                                    currentGroup: widget.currentGroup,
                                    currentBook: widget.book!,
                                    currentUser: widget.currentUser,
                                    authModel: widget.authModel,
                                    fromRoute: "fromHistory",
                                  )));
                        },
                        child: Text(
                          "MODIFIER",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton.icon(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.check,
            //         ),
            //         label: Text("Lu")),
            //     _displayFavorite(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
