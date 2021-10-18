import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/groupManage.dart';
import 'package:book_club_ref/screens/administration/profileManage.dart';

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const AppDrawer(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToGroupManage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GroupManage(
                currentGroup: currentGroup,
              )));
    }

    void _goToProfileManage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileManage()));
    }

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Row(
              children: [Text("data")],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                    leading: Icon(Icons.person),
                    title: const Text("Profil"),
                    onTap: () => _goToProfileManage()),
                ListTile(
                  leading: Icon(Icons.group),
                  title: const Text("Groupe"),
                  onTap: () => _goToGroupManage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
