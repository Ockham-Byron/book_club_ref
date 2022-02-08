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
  final String sectionCategory;
  const BookSection(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel,
      required this.sectionCategory})
      : super(key: key);

  @override
  _BookSectionState createState() => _BookSectionState();
}

class _BookSectionState extends State<BookSection> {
  String nothingText = "";
  late Future<List<BookModel>> books = DBFuture()
      .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);

  @override
  void initState() {
    super.initState();

    _initSections().whenComplete(() {
      setState(() {});
    });
  }

  Future _initSections() async {
    if (widget.sectionCategory == "continuer") {
      books = DBFuture()
          .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);
      nothingText = "Rien à lire pour l'instant !";
    } else if (widget.sectionCategory == "favoris") {
      books = DBFuture().getFavoriteBooks(widget.groupId, widget.currentUser);
      nothingText = "Aucun favori pour l'instant";
    }
  }

  // @override
  // void didChangeDependencies() async {
  //   if (widget.sectionCategory == "continuer") {
  //     books = DBFuture()
  //         .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);
  //     nothingText = "Rien à lire pour l'instant !";
  //   } else if (widget.sectionCategory == "favoris") {
  //     books = DBFuture().getFavoriteBooks(widget.groupId, widget.currentUser);
  //     nothingText = "Aucun favori pour l'instant";
  //   }

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: books,
      builder: (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.length > 0) {
            return Container(
              padding: EdgeInsets.only(top: 20),
              width: 350,
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container();
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
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                nothingText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
