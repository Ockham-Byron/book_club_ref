import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

import '../reviewHistory.dart';

class EachBook extends StatelessWidget {
  final BookModel? book;
  final String? groupId;
  final GroupModel currentGroup;
  final UserModel currentUser;
  const EachBook(
      {Key? key,
      this.book,
      this.groupId,
      required this.currentGroup,
      required this.currentUser})
      : super(key: key);

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (book!.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = book!.cover!;
    }

    return currentBookCoverUrl;
  }

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId!,
          bookId: book!.id!,
          currentGroup: currentGroup,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                child: Image.network(_currentBookCoverUrl()),
              ),
              Column(
                children: [
                  Text(
                    book!.title ?? "Pas de titre",
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).focusColor),
                  ),
                  Text(
                    book!.author ?? "Pas d'auteur",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
              )
            ],
          ),
          ElevatedButton(
              onPressed: () => _goToReviewHistory(context),
              child: Text("Voir les critiques"))
        ],
      ),
    );
  }
}
