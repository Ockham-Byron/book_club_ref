import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/reviewModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/editScreens/editReview.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachReview extends StatefulWidget {
  final ReviewModel review;
  final UserModel currentUser;
  final GroupModel currentGroup;
  final BookModel book;
  final AuthModel authModel;

  EachReview(
      {required this.review,
      required this.currentUser,
      required this.currentGroup,
      required this.book,
      required this.authModel});

  @override
  _EachReviewState createState() => _EachReviewState();
}

class _EachReviewState extends State<EachReview> {
  UserModel user = UserModel();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    user = await DBFuture().getUser(widget.review.userId!);
    setState(() {});
  }

  void _goToEditReview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditReview(
              currentGroup: widget.currentGroup,
              book: widget.book,
              currentReview: widget.review,
              currentUser: widget.currentUser,
              authModel: widget.authModel,
            )));
  }

  Widget _editWidget() {
    if (widget.currentUser.uid! == widget.review.userId) {
      return GestureDetector(
        onTap: () => _goToEditReview(),
        child: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                (user.uid != null) ? user.pseudo! : "pas de nom ?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                child: Text(
                  "Note : " + widget.review.rating.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).focusColor),
                ),
              ),
            ],
          ),
          Container(
            height: 80,
            child: VerticalDivider(
              thickness: 1,
              width: 10,
              color: Theme.of(context).focusColor,
            ),
          ),
          (widget.review.review != null)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.review.review!,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              : Text(""),
          _editWidget(),
        ],
      ),
    );
  }
}
