import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

import '../reviewHistory.dart';

class EachSeveralBook extends StatelessWidget {
  final BookModel? book;
  final String? groupId;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final UserModel owner;
  final UserModel? lender;
  final int? nbOfReaders;
  final int? nbOfMembers;
  const EachSeveralBook(
      {Key? key,
      this.book,
      this.groupId,
      required this.currentGroup,
      required this.currentUser,
      required this.owner,
      this.lender,
      this.nbOfMembers,
      this.nbOfReaders})
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

  String _displayOwner() {
    if (currentUser.uid == owner.uid) {
      return "toi";
    } else {
      return owner.pseudo!;
    }
  }

  String _displayLender() {
    if (lender!.uid != null) {
      if (currentUser.uid == lender!.uid) {
        return "toi";
      } else {
        return lender!.pseudo!;
      }
    } else {
      return "personne";
    }
  }

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId!,
          bookId: book!.id!,
          currentGroup: currentGroup,
          currentBook: book!,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        children: [
          Column(
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
              Row(
                children: [
                  Column(
                    children: [
                      Text("Livre de"),
                      Text(_displayOwner()),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Livre emprunté par "),
                      Text(_displayLender()),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () => _goToReviewHistory(context),
                  child: Text("Voir les critiques"))
            ],
          ),
          Column(
            children: [
              Text("Livre lu par"),
              Text(nbOfReaders.toString() + " / " + nbOfMembers.toString())
            ],
          )
        ],
      ),
    );
  }
}
