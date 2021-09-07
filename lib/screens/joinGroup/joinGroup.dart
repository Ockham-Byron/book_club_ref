import 'package:book_club_ref/widgets/ourContainer.dart';
import 'package:book_club_ref/states/currentUser.dart';
import 'package:book_club_ref/services/database.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurJoinGroup extends StatefulWidget {
  const OurJoinGroup({Key? key}) : super(key: key);

  @override
  _OurJoinGroupState createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {
  void _joinGroup(BuildContext context, String groupId) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDataBase()
        .joinGroup(groupId, _currentUser.getCurrentUser!.userId!);
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
            child: OurContainer(
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
