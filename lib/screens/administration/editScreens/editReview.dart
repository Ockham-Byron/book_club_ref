import 'dart:ui';

import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/reviewModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';
import 'package:book_club_ref/screens/bookHistory/reviewHistory.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditReview extends StatefulWidget {
  final GroupModel currentGroup;
  final BookModel book;
  final ReviewModel currentReview;
  final UserModel currentUser;
  final AuthModel authModel;

  const EditReview({
    Key? key,
    required this.currentGroup,
    required this.book,
    required this.currentReview,
    required this.currentUser,
    required this.authModel,
  }) : super(key: key);

  @override
  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  bool? initialFavorite;
  String? initialReview;
  int? initialRating;
  int _bookRatingInput = 1;
  bool _favoriteInput = false;

  @override
  void initState() {
    initialFavorite = widget.currentReview.favorite;
    initialReview = widget.currentReview.review;
    initialRating = widget.currentReview.rating;

    _bookReviewInput.text = initialReview!;

    _bookRatingInput = initialRating!;
    _favoriteInput = initialFavorite!;

    super.initState();
  }

  TextEditingController _bookReviewInput = TextEditingController();

  void _editReview(
    String userId,
    String groupId,
    String bookId,
    String review,
    bool favorite,
    int rating,
  ) async {
    String _returnString;

    _returnString = await DBFuture().editReview(
        groupId: groupId,
        bookId: bookId,
        userId: userId,
        review: review,
        rating: rating,
        favorite: favorite);

    if (_returnString == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ReviewHistory(
                bookId: widget.book.id!,
                groupId: widget.currentGroup.id!,
                currentGroup: widget.currentGroup,
                currentBook: widget.book,
                currentUser: widget.currentUser,
                authModel: widget.authModel,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ShadowContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Evaluez le livre de 1 à 10",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                      DropdownButton<int>(
                          value: _bookRatingInput,
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Theme.of(context).primaryColor,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                          underline: Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 2,
                            color: Theme.of(context).focusColor,
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              _bookRatingInput = newValue!;
                            });
                          },
                          items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList())
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: ShadowContainer(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _bookReviewInput,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).canvasColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          prefixIcon: Icon(
                            Icons.question_answer,
                            color: Theme.of(context).primaryColor,
                          ),
                          labelText: "Votre avis",
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ShadowContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ce livre fait-il partie de vos favoris ?"),
                      SizedBox(width: 20),
                      FavoriteButton(
                        iconColor: Theme.of(context).primaryColor,
                        isFavorite: initialFavorite,
                        valueChanged: (_isFavorite) {
                          if (_isFavorite == false) {
                            _favoriteInput = false;
                          } else {
                            _favoriteInput = true;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  _editReview(
                      widget.currentUser.uid!,
                      widget.currentGroup.id!,
                      widget.book.id!,
                      _bookReviewInput.text,
                      _favoriteInput,
                      _bookRatingInput);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Modifier".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
