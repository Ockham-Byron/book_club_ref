import 'package:book_club_ref/models/groupModel.dart';

import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/inGroup/localwidgets/secondCard.dart';
import 'package:book_club_ref/screens/inGroup/localwidgets/topCard.dart';

import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGroup extends StatefulWidget {
  const InGroup({Key? key}) : super(key: key);

  @override
  _InGroupState createState() => _InGroupState();
}

class _InGroupState extends State<InGroup> {
  GroupModel _currentGroup = GroupModel();

  @override
  void didChangeDependencies() async {
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

  Widget build(BuildContext context) {
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
              Icons.outbond_rounded,
              color: Colors.white,
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          TopCard(),
          SizedBox(
            height: 2,
          ),
          SecondCard(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
            child: ElevatedButton(
                onPressed: () {},
                child: Text("Voir l'historique du club de lecture"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor))),
          ),
        ],
      ),
    );
  }
}
