import 'package:book_club_ref/models/reviewModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachReview extends StatefulWidget {
  final ReviewModel review;

  EachReview({required this.review});

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

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            (user.uid != null) ? user.pseudo! : "c'est quoi déjà votre nom ?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Note : " + widget.review.rating.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          (widget.review.review != null)
              ? Text(
                  widget.review.review!,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                )
              : Text(""),
        ],
      ),
    );
  }
}
