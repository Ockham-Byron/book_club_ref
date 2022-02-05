import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/reviewModel.dart';

import 'package:book_club_ref/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    String retVal = "error";
    List<String> readBooks = [];
    List<String> favoriteBooks = [];
    List<String> dontWantToReadBooks = [];

    try {
      await _firestore.collection("users").doc(user.uid).set({
        "pseudo": user.pseudo!.trim(),
        "email": user.email!.trim(),
        "pictureUrl": user.pictureUrl.trim(),
        "accountCreated": Timestamp.now(),
        "readBooks": readBooks,
        "favoriteBooks": favoriteBooks,
        "readPages": user.readPages,
        "dontWantToReadBooks": dontWantToReadBooks
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editUserPseudo(String userId, String pseudo) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        "pseudo": pseudo.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editUserMail(String userId, String mail) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        "email": mail.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editUserPicture(String userId, String pictureUrl) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        "pictureUrl": pictureUrl.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editGroupName(
      {required String groupId, required String groupName}) async {
    String retVal = "error";

    try {
      await _firestore.collection("groups").doc(groupId).update({
        "name": groupName.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editBook({
    required String groupId,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    required String bookCover,
    required int bookPages,
    required Timestamp dateCompleted,
  }) async {
    String retVal = "error";

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .update({
        "title": bookTitle.trim(),
        "author": bookAuthor.trim(),
        "cover": bookCover.trim(),
        "length": bookPages,
        "dateCompleted": dateCompleted,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //Edit Review
  Future<String> editReview({
    required String userId,
    required String groupId,
    required String bookId,
    required String review,
    required bool favorite,
    required int rating,
  }) async {
    String retVal = "error";

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(userId)
          .update({
        "review": review.trim(),
        "rating": rating,
        "favorite": favorite,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //EditUser
  Future<String> editUserProfile({
    required String userId,
    required String userPseudo,
    required String userPicture,
  }) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        "pseudo": userPseudo.trim(),
        "pictureUrl": userPicture.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //Delete User
  Future<String> deleteUserFromDb(
      GroupModel currentGroup, String userId, String groupId) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(userId).delete();

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> deleteUserFromGroup(
      GroupModel currentGroup, String userId, String groupId) async {
    String retVal = "error";

    try {
      await _firestore.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayRemove([userId])
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
    String groupName,
    UserModel user,
    //BookModel initialBook
  ) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(user.uid!);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name": groupName.trim(),
        "leader": user.uid,
        "members": members,
        "groupCreated": Timestamp.now(),
        "currentBookId": null,
        "indexPickingBook": 0,
        "nbOfBooks": 0
      });
      await _firestore.collection("users").doc(user.uid).update({
        "groupId": _docRef.id,
      });

      //add firstBook
      //addBook(_docRef.id, initialBook);
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

  Future<GroupModel> getGroup(String groupId) async {
    GroupModel retVal = GroupModel();

    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot =
          await _firestore.collection("groups").doc(groupId).get();
      retVal = GroupModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<BookModel> getBook(String bookId, String groupId) async {
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
        "dateCompleted": book.dateCompleted,
        "cover": book.cover
      });

      //add book to the Group schedule
      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
        "nbOfBooks": FieldValue.increment(1)
      });

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
        'cover': book.cover,
        'owner': book.ownerId,
        'lender': book.lenderId,
      });

      //add current book to group schedule
      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
        "nbOfBooks": FieldValue.increment(1)
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(
      String groupId, BookModel book, int nextPicker) async {
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
        "dateCompleted": book.dateCompleted,
        "cover": book.cover
      });

      //add book to the Group schedule
      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
        "indexPickingBook": nextPicker,
        "nbOfBooks": FieldValue.increment(1),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> changeBook(String groupId) async {
    String retVal = "error";

    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot =
          await _firestore.collection("groups").doc(groupId).get();

      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docSnapshot.data()!["nextBookId"],
        "currentBookDue": _docSnapshot.data()!["nextBookDue"],
        "nextBookId": "en attente",
        "nextBookDue": null,
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
      String groupId, String bookId, String userId) async {
    bool retVal = false;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(userId)
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
      int rating, String review, int nbPages, bool favorite) async {
    String retVal = "error";
    List<String> readBooks = [];

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .set({"rating": rating, "review": review, "favorite": favorite});

      //add finished Book in user profile
      readBooks.add(bookId);
      await _firestore.collection("users").doc(uid).update({
        "readBooks": FieldValue.arrayUnion(readBooks),
        "readPages": FieldValue.increment(nbPages)
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> dontWantToReadBook(String bookId, String userId) async {
    String retVal = "error";
    List<String> dontWantToReadBooks = [];

    try {
      dontWantToReadBooks.add(bookId);
      await _firestore.collection("users").doc(userId).update(
          {"dontWantToReadBooks": FieldValue.arrayUnion(dontWantToReadBooks)});
      retVal = "success";
    } catch (e) {}

    return retVal;
  }

  Future<bool> getDontWantToReadBooks(String groupId, UserModel user) async {
    bool retVal = false;

    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .get();

      query.docs.forEach((element) {
        if (user.dontWantToReadBooks!.contains(element.id)) {
          retVal = true;
        }
      });
    } catch (e) {}

    return retVal;
  }

  Future<List<BookModel>> getContinueReadingBooks(
      String groupId, UserModel user) async {
    List<BookModel> retVal = [];

    try {
      QuerySnapshot<Map<String, dynamic>> queryAllBooks = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .get();

      queryAllBooks.docs.forEach((element) async {
        if (user.dontWantToReadBooks!.contains(element.id)) {
          print("il ne veut plus le lire");
        } else {
          if (user.readBooks!.contains(element.id)) {
            print("il l'a déjà lu");
          } else {
            retVal.add(BookModel.fromDocumentSnapshot(doc: element));
            print("pas encore lu mais il veut le lire");
          }
        }
      });
      print("pseudo user : " + user.pseudo!);
      print(retVal);
    } catch (e) {}

    return retVal;
  }

  Future<List<BookModel>> getFavoriteBooks(
      String groupId, UserModel user) async {
    List<BookModel> retVal = [];

    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .get();

      query.docs.forEach((element) async {
        print(element.id);
        print(user.pseudo);
        print(user.readBooks);
        if (user.favoriteBooks!.contains(element.id)) {
          retVal.add(BookModel.fromDocumentSnapshot(doc: element));
          print("ajouter aux favoris");
        } else {
          print("aucun favori");
        }
      });
    } catch (e) {}

    return retVal;
  }

  Future<String> favoriteBook(
    String groupId,
    String bookId,
    String uid,
  ) async {
    String retVal = "error";
    List<String> favoriteBooks = [];

    try {
      favoriteBooks.add(bookId);
      await _firestore.collection("users").doc(uid).update({
        "favoriteBooks": FieldValue.arrayUnion(favoriteBooks),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> cancelFavoriteBook(
    String groupId,
    String bookId,
    String uid,
  ) async {
    String retVal = "error";
    List<String> favoriteBooks = [];

    try {
      favoriteBooks.add(bookId);
      await _firestore.collection("users").doc(uid).update({
        "favoriteBooks": FieldValue.arrayRemove(favoriteBooks),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<BookModel>> getBookHistory(String groupId) async {
    List<BookModel> retVal = [];

    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)
          .get();

      query.docs.forEach((element) {
        retVal.add(BookModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<ReviewModel>> getReviewHistory(
      GroupModel currentGroup, String groupId, String bookId) async {
    List<ReviewModel> retVal = [];

    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .get();

      query.docs.forEach((element) {
        if (currentGroup.members!.contains(element.id)) {
          retVal.add(ReviewModel.fromDocumentSnapshot(doc: element));
        } else {
          _firestore
              .collection("groups")
              .doc(groupId)
              .collection("books")
              .doc(bookId)
              .collection("reviews")
              .doc(element.id)
              .delete();
        }
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<int> getNbOfReviews(String groupId, String bookId) async {
    int retVal = 0;
    List<DocumentSnapshot> _myDocCount = [];

    try {
      QuerySnapshot _myDoc = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .get();

      _myDocCount = _myDoc.docs;
      retVal = _myDocCount.length;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<int> getNbOfFavorites(String groupId, String bookId) async {
    int nbOfFavorites = 0;
    List<String> favorites = [];
    List<ReviewModel> reviews = [];

    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .get();

      query.docs.forEach((element) {
        reviews.add(ReviewModel.fromDocumentSnapshot(doc: element));
      });
      for (ReviewModel reviewItem in reviews) {
        if (reviewItem.favorite == true) {
          favorites.add(reviewItem.userId!);
        }
      }
      nbOfFavorites = favorites.length;
    } catch (e) {
      print(e);
    }
    return nbOfFavorites;
  }

  Future<List<UserModel>> getAllUsers(GroupModel currentGroup) async {
    List<UserModel> retVal = [];

    try {
      QuerySnapshot<Map<String, dynamic>> query =
          await _firestore.collection("users").get();

      query.docs.forEach((element) {
        if (currentGroup.members!.contains(element.id)) {
          retVal.add(UserModel.fromDocumentSnapshot(doc: element));
        }
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> changePicker(String groupId) async {
    String retVal = "error";

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .update({"indexPickingBook": FieldValue.increment(1)});
    } catch (e) {}

    return retVal;
  }

  Future<String> changePickerFromStart(String groupId) async {
    String retVal = "error";

    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .update({"indexPickingBook": 0});
    } catch (e) {}

    return retVal;
  }
}
