import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/profileManage%20copy.dart';
import 'package:book_club_ref/screens/bookHistory/reviewHistory.dart';
import 'package:book_club_ref/screens/review/addareview.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class FinishedBook extends StatelessWidget {
  final BookModel finishedBook;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const FinishedBook(
      {Key? key,
      required this.finishedBook,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 230, horizontal: 20),
        child: ShadowContainer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddReview(
                              bookId: finishedBook.id!,
                              fromRoute: ReviewHistory(
                                bookId: finishedBook.id!,
                                groupId: currentGroup.id!,
                                currentBook: finishedBook,
                                currentGroup: currentGroup,
                                currentUser: currentUser,
                                authModel: authModel,
                              ),
                              currentGroup: currentGroup,
                            )));
              },
              child: Text("Vous avez terminé le livre ?"),
            ),
            ElevatedButton(
              onPressed: () {
                DBFuture()
                    .dontWantToReadBook(finishedBook.id!, currentUser.uid!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileManage(
                          currentUser: currentUser,
                          currentGroup: currentGroup,
                          currentBook: finishedBook,
                          authModel: authModel)),
                );
              },
              child: Text("Vous ne comptez pas terminer ce livre ?"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "ANNULER",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                ))
          ],
        )),
      ),
    ));
  }
}
