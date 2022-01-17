import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/administration/editScreens/editGroupName.dart';
import 'package:book_club_ref/screens/administration/localwidgets/memberCard.dart';
import 'package:book_club_ref/screens/bookHistory/bookHistory.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/appDrawer.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupManageRef extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel currentBook;
  final AuthModel authModel;
  const GroupManageRef(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.currentBook,
      required this.authModel})
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

  String _displayGroupName() {
    if (widget.currentGroup.name != null) {
      return widget.currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  Widget displayCircularAvatar() {
    if (withProfilePicture()) {
      return CircularProfileAvatar(
        widget.currentUser.pictureUrl,
        showInitialTextAbovePicture: false,
      );
    } else {
      return CircularProfileAvatar(
        "https://digitalpainting.school/static/img/default_avatar.png",
        foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
        initialsText: Text(
          widget.currentUser.pseudo![0].toUpperCase(),
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        showInitialTextAbovePicture: true,
      );
    }
  }

  int getGroupBooks() {
    int groupBooks;
    if (widget.currentGroup.nbOfBooks != null) {
      groupBooks = widget.currentGroup.nbOfBooks!;
    } else {
      groupBooks = 0;
    }
    return groupBooks;
  }

  int getNbGroupMembers() {
    int groupMembers;
    if (widget.currentGroup.members != null) {
      groupMembers = widget.currentGroup.members!.length;
    } else {
      groupMembers = 0;
    }
    return groupMembers;
  }

  void _goToHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHistory(
          groupId: widget.currentGroup.id!,
          groupName: widget.currentGroup.name!,
          currentGroup: widget.currentGroup,
          currentUser: widget.currentUser,
        ),
      ),
    );
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
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.93,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: FutureBuilder(
            future: members,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Builder(
                                      builder: (context) => GestureDetector(
                                        child: displayCircularAvatar(),
                                        onTap: () =>
                                            Scaffold.of(context).openDrawer(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      _displayGroupName(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditGroupName(
                                                        currentGroup:
                                                            widget.currentGroup,
                                                      )));
                                        },
                                        child: Text(
                                          "MODIFIER",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ))
                                  ],
                                ),

                                SizedBox(
                                  width: 20,
                                ),
                                // IconButton(
                                //   icon: Icon(
                                //     Icons.logout_rounded,
                                //     color: Colors.white,
                                //   ),
                                //   onPressed: () => _signOut(context),
                                // )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "LIVRES",
                                      style: kTitleStyle,
                                    ),
                                    Text(
                                      "MEMBRES",
                                      style: kTitleStyle,
                                    ),
                                    // Text(
                                    //   "CRITIQUES",
                                    //   style: kTitleStyle,
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      getGroupBooks().toString(),
                                      style: kSubtitleStyle,
                                    ),
                                    Text(
                                      getNbGroupMembers().toString(),
                                      style: kSubtitleStyle,
                                    ),
                                    // Text(
                                    //   "47",
                                    //   style: kSubtitleStyle,
                                    // ),
                                  ],
                                )
                              ],
                            ),
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
                            ElevatedButton(
                                onPressed: _goToHistory,
                                child: Text("Voir tous les livres du groupe")),
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              "Membres du groupe",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
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
        ),
      ),
      drawer: AppDrawer(
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
        currentBook: widget.currentBook,
        authModel: widget.authModel,
      ),
    );
  }
}

final kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
