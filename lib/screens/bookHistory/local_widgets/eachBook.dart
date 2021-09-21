import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

import '../reviewHistory.dart';

class EachBook extends StatelessWidget {
  final BookModel? book;
  final String? groupId;
  const EachBook({Key? key, this.book, this.groupId}) : super(key: key);

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          bookId: book!.id,
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
                height: 200,
                width: 80,
                child: Image.network(book!.cover ??
                    "https://www.azendportafolio.com/static/img/not-found.png"),
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
