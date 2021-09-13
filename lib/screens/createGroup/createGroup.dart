import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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

  TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [BackButton()],
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _groupNameInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Nom du groupe",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AddBook(
                      groupName: _groupNameInput.text,
                      onGroupCreation: true,
                    ),
                  ),
                  (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Créez le groupe".toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
