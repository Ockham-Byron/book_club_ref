import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/groupManageRef.dart';

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
          builder: (context) => GroupManageRef(
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Profil",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                    onTap: () => _goToProfileManage()),
                ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Groupe",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                  onTap: () => _goToGroupManage(),
                ),
                SizedBox(
                  height: 100,
                ),
                Image.network(
                  "https://cdn.pixabay.com/photo/2018/04/24/11/32/book-3346785_1280.png",
                  fit: BoxFit.contain,
                  width: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
