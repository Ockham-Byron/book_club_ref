import 'package:book_club_ref/models/bookModel.dart';

import 'package:book_club_ref/models/groupModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class OurDataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<String> createUser(UserModel user) async {
  //   String retVal = "error";

  //   try {
  //     await _firestore.collection("users").doc(user.uid).set({
  //       "pseudo": user.pseudo,
  //       "email": user.email,
  //       "accountCreated": Timestamp.now(),
  //     });
  //     retVal = "success";
  //   } catch (e) {
  //     print(e);
  //   }
  //   return retVal;
  // }

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

  Future<GroupModel> getGroupInfo(String groupId) async {
    GroupModel retVal = GroupModel();

    try {
      DocumentSnapshot<Map<Object, dynamic>> _docSnapshot =
          await _firestore.collection("groups").doc(groupId).get();
      retVal.id = groupId;
      retVal.name = _docSnapshot.data()!["name"];
      //retVal.members = List<String>.from(_docSnapshot.data()!["members"]);
      retVal.leader = _docSnapshot.data()!["leader"];
      retVal.groupCreated = _docSnapshot.data()!["groupCreated"];
      retVal.currentBookId = _docSnapshot.data()!["currentBookId"];
      retVal.currentBookDue = _docSnapshot.data()!["currentBookDue"];
    } catch (e) {}

    return retVal;
  }

  Future<BookModel> getCurrentBook(String groupId, String bookId) async {
    BookModel retVal = BookModel();

    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .get();
      retVal.id = bookId;
      retVal.title = _docSnapshot.data()!["title"];
      retVal.author = _docSnapshot.data()!["author"];
      retVal.length = _docSnapshot.data()!["length"];
      retVal.dateCompleted = _docSnapshot.data()!["dateCompleted"];
    } catch (e) {}

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

  Future<String> finishedBook(String groupId, String bookId, String uid,
      int rating, String review) async {
    String retVal = "error";

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .set({"rating": rating, "review": review});
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<bool> isUserDoneWithTheBook(
      String groupId, String bookId, String uid) async {
    bool retVal = false;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
