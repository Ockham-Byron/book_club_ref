import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';

import 'package:flutter/material.dart';

import 'local_widgets/eachBook.dart';

class FavoriteHistory extends StatefulWidget {
  final String groupId;
  final String groupName;
  final GroupModel currentGroup;
  final UserModel currentUser;
  final AuthModel authModel;
  const FavoriteHistory(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.currentGroup,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  _FavoriteHistoryState createState() => _FavoriteHistoryState();
}

class _FavoriteHistoryState extends State<FavoriteHistory> {
  late Future<List<BookModel>> books =
      DBFuture().getBookHistory(widget.groupId);

  @override
  void didChangeDependencies() async {
    books = DBFuture().getBookHistory(widget.groupId);

    super.didChangeDependencies();
  }

  void _signOut(BuildContext context) async {
    String _returnedString = await Auth().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurRoot(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.outbond_rounded,
              color: Colors.white,
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: FutureBuilder(
        future: books,
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Text("");
                  // return Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Row(
                  //     children: [
                  //       BackButton(),
                  //     ],
                  //   ),
                  // );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: EachBook(
                      book: snapshot.data![index - 1],
                      groupId: widget.groupId,
                      currentGroup: widget.currentGroup,
                      currentUser: widget.currentUser,
                      authModel: widget.authModel,
                    ),
                  );
                }
              },
            );
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
