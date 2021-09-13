import 'package:book_club_ref/models/bookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGroup(
      String groupName, String uid, BookModel initialBook) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(uid);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name": groupName,
        "leader": uid,
        "members": members,
        "groupCreated": Timestamp.now(),
        "currentBookDue": initialBook.dateCompleted,
      });
      await _firestore.collection("users").doc(uid).update({
        "groupId": _docRef.id,
      });

      //add firstBook
      addBook(_docRef.id, initialBook);
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").doc(userUid).update({
        "groupId": groupId,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> addBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        "title": book.title,
        "author": book.author,
        "length": book.length,
        "dateCompleted": book.dateCompleted
      });

      //add book to the Group schedule
      await _firestore.collection("groups").doc(groupId).update(
          {"currentBookId": _docRef.id, "currentBookDue": book.dateCompleted});
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
