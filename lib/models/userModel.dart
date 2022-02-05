import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  Timestamp? accountCreated;
  String? pseudo;

  String? groupId;
  String pictureUrl =
      "https://digitalpainting.school/static/img/default_avatar.png";
  List<String>? readBooks;
  List<String>? dontWantToReadBooks;
  List<String>? favoriteBooks;
  int? readPages;

  UserModel({
    this.uid,
    this.email,
    this.pseudo,
    this.accountCreated,
    this.readBooks,
    this.readPages,
    this.dontWantToReadBooks,
    this.favoriteBooks,
    this.pictureUrl =
        "https://digitalpainting.school/static/img/default_avatar.png",
  });

  UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    uid = doc.id;
    email = doc.data()!["email"];
    pseudo = doc.data()!["pseudo"];
    accountCreated = doc.data()!["accountCreated"];

    groupId = doc.data()!["groupId"];
    readBooks = List<String>.from(doc.data()!["readBooks"]);
    dontWantToReadBooks = List<String>.from(doc.data()!["dontWantToReadBooks"]);
    favoriteBooks = List<String>.from(doc.data()!["favoriteBooks"]);
    readPages = doc.data()!["readPages"];
    pictureUrl = doc.data()!["pictureUrl"];
  }
}
