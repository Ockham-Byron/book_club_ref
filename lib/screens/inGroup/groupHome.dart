//import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/inGroup/SingleBookHome.dart';
import 'package:book_club_ref/screens/inGroup/groupSingleBook.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key}) : super(key: key);

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  late GroupModel _currentGroup;
  late UserModel _currentUser;
  late AuthModel _authModel;

  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    _currentGroup = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    super.didChangeDependencies();
  }

  void _goToAddBook() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => AddBook(
                  onGroupCreation: false,
                  onError: false,
                  currentUser: _currentUser,
                  currentGroup: _currentGroup,
                )),
        (route) => false);
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
    if (_currentGroup.currentBookId == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Consumer<GroupModel>(
            builder: (BuildContext context, value, Widget? child) {
              var _currentGroupName = value.name ?? "Groupe sans nom";
              return Text(
                _currentGroupName,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () => _signOut(context),
            )
          ],
        ),
        body: Column(
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
                "Il n'y a pas encore de livre dans ce groupe ;(",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () => _goToAddBook(),
              child: Text("Ajouter le premier livre"),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      );
    } else {
      return SingleBookHome(
        currentGroup: _currentGroup,
        groupId: _currentGroup.id!,
        authModel: _authModel,
        currentUser: _currentUser,
      );
    }
  }
}
