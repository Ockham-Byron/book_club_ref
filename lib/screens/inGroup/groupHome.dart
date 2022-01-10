//import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/inGroup/SingleBookHome.dart';
import 'package:book_club_ref/screens/inGroup/localwidgets/groupWithoutBook.dart';

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
      return GroupWithoutBook(
        currentGroup: _currentGroup,
        currentUser: _currentUser,
        authModel: _authModel,
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
