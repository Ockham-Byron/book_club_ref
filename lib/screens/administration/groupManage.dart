import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/localwidgets/memberCard.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupManage extends StatefulWidget {
  final GroupModel currentGroup;
  const GroupManage({Key? key, required this.currentGroup}) : super(key: key);

  @override
  _GroupManageState createState() => _GroupManageState();
}

class _GroupManageState extends State<GroupManage> {
  UserModel _user = UserModel();

  String? _getGroupId() {
    String? groupId;
    if (widget.currentGroup.id != null) {
      groupId = widget.currentGroup.id;
    } else {
      groupId = "Id inconnu, ce qui est très étrange";
    }
    return groupId;
  }

  // This key will be used to show the snack bar
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _getGroupId()));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Copié dans le presse papier")));
  }

  List<String>? getGroupMembers() {
    List<String>? groupMembers;
    if (widget.currentGroup.members!.length < 0) {
      print("0 membres, comme c'est bizarre");
      groupMembers = [widget.currentGroup.leader!];
    } else {
      groupMembers = widget.currentGroup.members!;
    }
    return groupMembers;
  }

  Future getUser(int index) async {
    _user = DBFuture().getUser(getGroupMembers()![index]) as UserModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
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
            Text("Membres"),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: getGroupMembers()!.length,
                itemExtent: 100,
                itemBuilder: (BuildContext context, int index) {
                  return MemberCard(
                    user: UserModel(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
