import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
  final UserModel userModel;
  const JoinGroup({Key? key, required this.userModel}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  void _joinGroup(BuildContext context, String groupId) async {
    UserModel _currentUser = widget.userModel;
    String _returnString = await DBFuture().joinGroup(groupId, _currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
  }

  TextEditingController _groupIdInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: _groupIdInput,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.group),
                    hintText: "code du groupe",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => _joinGroup(context, _groupIdInput.text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Joindre le groupe".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
