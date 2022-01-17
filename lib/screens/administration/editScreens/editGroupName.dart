import 'dart:ui';

import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EditGroupName extends StatefulWidget {
  final GroupModel currentGroup;
  const EditGroupName({Key? key, required this.currentGroup}) : super(key: key);

  @override
  _EditGroupNameState createState() => _EditGroupNameState();
}

class _EditGroupNameState extends State<EditGroupName> {
  FocusNode? fgrname;
  String? _groupName;

  void _editGroupName(String groupId, String groupName) async {
    String _returnString;

    _returnString =
        await DBFuture().editGroupName(groupId: groupId, groupName: groupName);

    if (_returnString == "success") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => OurRoot()));
    }
  }

  TextEditingController _groupNameInput = TextEditingController();
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
          child: Center(
            child: Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      autofocus: true,
                      focusNode: fgrname,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(fgrname);
                        });
                      },
                      textInputAction: TextInputAction.next,
                      controller: _groupNameInput,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Nom du groupe",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _groupName = _groupNameInput.text;

                        _editGroupName(widget.currentGroup.id!, _groupName!);
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
          ),
        ),
      ),
    );
  }
}
