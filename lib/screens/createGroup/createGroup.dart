import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  final UserModel userModel;
  const CreateGroup({Key? key, required this.userModel}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  FocusNode? fgrname;

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
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
      body: Center(
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
                    labelStyle: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                  style: Theme.of(context).textTheme.headline6,
                ),
                ElevatedButton(
                  onPressed: () {
                    UserModel currentUser = widget.userModel;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AddBook(
                            groupName: _groupNameInput.text,
                            currentUser: currentUser,
                            onGroupCreation: true,
                            onError: false,
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
          ),
        ),
      ),
    );
  }
}
