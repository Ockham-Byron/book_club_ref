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
                          book!.title ?? "Pas de titre",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          book!.author ?? "Pas d'auteur",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Transform.rotate(
                    angle: 300,
                    child: Text("MODIFIER"),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                    ),
                    label: Text("Lu")),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.favorite),
                    label: Text("Favori"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
