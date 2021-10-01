import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? id;
  String? name;
  String? leader;
  List<String>? members;
  Timestamp? groupCreated;
  String? currentBookId;
  int? indexPickingBook;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
    this.currentBookId,
    this.indexPickingBook,
  });

  GroupModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    id = doc.id;
    name = doc.data()!["name"];
    leader = doc.data()!["leader"];
    members = List<String>.from(doc.data()!["members"]);
    groupCreated = doc.data()!["groupCreated"];
    currentBookId = doc.data()!["currentBookId"];
    indexPickingBook = doc.data()!["indexPickingBook"];
  }
}
