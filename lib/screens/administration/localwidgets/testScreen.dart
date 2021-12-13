import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final UserModel user;
  final GroupModel group;
  const TestScreen({Key? key, required this.user, required this.group})
      : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController _changeText = TextEditingController();
  String title = "coucou";

  void _editUserPseudo(
      String pseudo, String userId, BuildContext context) async {
    try {
      String _returnString = await DBFuture().editUserPseudo(userId, pseudo);
      if (_returnString == "success") {
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title),
              TextField(
                controller: _changeText,
              ),
              ElevatedButton(
                  onPressed: () => _editUserPseudo(
                      _changeText.text, widget.user.uid!, context),
                  child: Text("Changer le titre"))
            ],
          ),
        ),
      ),
    );
  }
}
