import 'package:book_club_ref/models/groupModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupManage extends StatefulWidget {
  final GroupModel currentGroup;
  const GroupManage({Key? key, required this.currentGroup}) : super(key: key);

  @override
  _GroupManageState createState() => _GroupManageState();
}

class _GroupManageState extends State<GroupManage> {
  String? _getGroupId() {
    String? groupId;
    if (widget.currentGroup.id != null) {
      return groupId = widget.currentGroup.id;
    } else {
      return groupId = "Id inconnu, ce qui est très étrange";
    }
  }

  // This key will be used to show the snack bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _getGroupId()));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Copié dans le presse papier")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Id du groupe à partager aux nouveaux membres"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_getGroupId()!),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  child: Icon(Icons.copy),
                  onTap: _copyToClipboard,
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text("Membres")
          ],
        ),
      ),
    );
  }
}
