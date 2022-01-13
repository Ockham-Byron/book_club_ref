import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/localwidgets/memberCard.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupManageRef extends StatefulWidget {
  final GroupModel currentGroup;
  const GroupManageRef({Key? key, required this.currentGroup})
      : super(key: key);

  @override
  _GroupManageRefState createState() => _GroupManageRefState();
}

class _GroupManageRefState extends State<GroupManageRef> {
  late Future<List<UserModel>> members =
      DBFuture().getAllUsers(widget.currentGroup);
  late Future<List<UserModel>> groupMembers = [] as Future<List<UserModel>>;

  @override
  void didChangeDependencies() async {
    members = DBFuture().getAllUsers(widget.currentGroup);

    super.didChangeDependencies();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: members,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Container(
                          width: 350,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor)),
                          child: Column(
                            children: [
                              Text(
                                  "Id du groupe à partager aux nouveaux membres"),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_getGroupId()!),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.copy,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onTap: _copyToClipboard,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: MemberCard(
                        user: snapshot.data![index - 1],
                        currentGroup: widget.currentGroup,
                      ),
                    );
                  }
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
