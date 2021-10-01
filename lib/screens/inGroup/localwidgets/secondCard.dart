import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/inGroup/groupHome.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondCard extends StatefulWidget {
  const SecondCard({Key? key}) : super(key: key);

  @override
  _SecondCardState createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> {
  late GroupModel _currentGroup;
  late UserModel _currentUser;
  late UserModel _pickingUser = UserModel();
  late BookModel _nextBook = BookModel();

  @override
  void didChangeDependencies() async {
    _currentGroup = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);

    _pickingUser = await DBFuture()
        .getUser(_currentGroup.members![_currentGroup.indexPickingBook!]);

    _nextBook = await DBFuture()
        .getCurrentBook(_currentGroup.id!, _currentGroup.currentBookId!);

    if (this.mounted) {
      setState(() {});
    }

    print(_currentUser.pseudo);
    print(_pickingUser.pseudo);
    super.didChangeDependencies();
  }

  Widget _displayNextBookInfo() {
    if (_pickingUser.uid != null) {
      if (_currentGroup.currentBookId == "en attente") {
        if (_pickingUser.uid == _currentUser.uid) {
          return Column(
            children: [
              Text(
                "C'est à ton tour de choisir le livre",
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).focusColor),
              ),
              SizedBox(
                height: 5,
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                onPressed: () => _goToAddBook(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        } else {
          String _pickingUserPseudo =
              _pickingUser.pseudo ?? "pas encore déterminé";
          return Column(
            children: [
              Text(
                "Prochain livre choisi par",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _pickingUserPseudo,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).focusColor,
                ),
              ),
            ],
          );
        }
      } else {
        return Column(
          children: [
            Text(
              "Voici le prochain livre",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _nextBook.title!,
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
            ),
            ElevatedButton(
                onPressed: () => _changeBook(),
                child: Text("En faire le livre en cours"))
          ],
        );
      }
    } else {
      return Text(
        "pas encore déterminé",
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).focusColor,
        ),
      );
    }
  }

  void _goToAddBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: false,
          onError: false,
          currentGroup: _currentGroup,
          currentUser: _pickingUser,
        ),
      ),
    );
  }

  void _changeBook() async {
    await DBFuture().changeBook(_currentGroup.id!);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GroupHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ShadowContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: _displayNextBookInfo(),
        ),
      ),
    );
  }
}
