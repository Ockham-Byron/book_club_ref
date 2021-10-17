import 'package:book_club_ref/screens/groupManage.dart';

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToGroupManage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GroupManage()));
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
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
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
