import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<UserModel> getcurrentUser(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(doc: docSnapshot));
  }

  Stream<GroupModel> getcurrentGroup(String groupId) {
    return _firestore.collection("groups").doc(groupId).snapshots().map(
        (docSnapshot) => GroupModel.fromDocumentSnapshot(doc: docSnapshot));
  }
}
