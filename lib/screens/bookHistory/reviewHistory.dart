import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/reviewModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/review/addareview.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:flutter/material.dart';

import 'local_widgets/eachReview.dart';

class ReviewHistory extends StatefulWidget {
  final UserModel currentUser;
  final String bookId;
  final String groupId;
  final GroupModel currentGroup;
  const ReviewHistory(
      {Key? key,
      required this.bookId,
      required this.groupId,
      required this.currentGroup,
      required this.currentUser})
      : super(key: key);

  @override
  _ReviewHistoryState createState() => _ReviewHistoryState();
}

class _ReviewHistoryState extends State<ReviewHistory> {
  late Future<List<ReviewModel>> reviews =
      DBFuture().getReviewHistory(widget.groupId, widget.bookId);
  bool _doneWithBook = false;

  @override
  void didChangeDependencies() async {
    reviews = DBFuture().getReviewHistory(widget.groupId, widget.bookId);
    //check if the user is done with book
    if (widget.currentGroup.currentBookId != null) {
      if (await DBFuture().isUserDoneWithBook(
          widget.currentGroup.id!, widget.bookId, widget.currentUser.uid!)) {
        _doneWithBook = true;
      } else {
        _doneWithBook = false;
      }
      print(_doneWithBook);

      print(widget.currentUser.uid);
    }
    super.didChangeDependencies();
  }

  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: widget.currentGroup,
          bookId: widget.bookId,
        ),
      ),
    );
  }

  Widget _displayAddReview() {
    if (!_doneWithBook) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: () => _goToReview(),
            child: Text("Indique que, toi, aussi, tu as terminé ce livre")),
      );
    } else {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: reviews,
        builder:
            (BuildContext context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                // scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _displayAddReview();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: EachReview(
                        review: snapshot.data![index - 1],
                      ),
                    );
                  }
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                          fit: BoxFit.contain),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Il n'y a pas encore de critique pour ce livre ;(",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _goToReview(),
                    child: Text("Ajouter la première critique"),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
