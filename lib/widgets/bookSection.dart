import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';

import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/bookCard.dart';

import 'package:flutter/material.dart';

class BookSection extends StatefulWidget {
  final String groupId;
  final String groupName;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const BookSection(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  _BookSectionState createState() => _BookSectionState();
}

class _BookSectionState extends State<BookSection> {
  late Future<List<BookModel>> books =
      DBFuture().getBookHistory(widget.groupId);

  @override
  void didChangeDependencies() async {
    books = DBFuture().getBookHistory(widget.groupId);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: books,
      builder: (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            width: 350,
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Text("");
                } else {
                  return BookCard(
                    book: snapshot.data![index - 1],
                    groupId: widget.groupId,
                    currentGroup: widget.currentGroup,
                    currentUser: widget.currentUser,
                    authModel: widget.authModel,
                  );
                }
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
