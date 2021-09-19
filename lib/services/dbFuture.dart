import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        "pseudo": user.pseudo!.trim(),
        "email": user.email!.trim(),
        "accountCreated": Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<UserModel> getUser(String uid) async {
    UserModel retVal = UserModel();

    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot =
          await _firestore.collection("users").doc(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(
      String groupName, UserModel user, BookModel initialBook) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(user.uid!);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name": groupName.trim(),
        "leader": user.uid,
        "members": members,
        "groupCreated": Timestamp.now(),
        "nextBookId": "en attente",
        "indexPickingBook": 0
      });
      await _firestore.collection("users").doc(user.uid).update({
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

  Future<String> joinGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userModel.uid!);
      await _firestore.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").doc(userModel.uid!).update({
        "groupId": groupId.trim(),
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

  Future<String> addCurrentBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        'name': book.title!.trim(),
        'author': book.author!.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
      });

      //adding a notification document

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(String groupId, BookModel book) async {
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
      await _firestore.collection("groups").doc(groupId).update({
        "nextBookId": _docRef.id,
        "nextBookDue": book.dateCompleted,
        "indexPickingBook": FieldValue.increment(1)
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
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
      retVal = BookModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<bool> isUserDoneWithBook(
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
}
