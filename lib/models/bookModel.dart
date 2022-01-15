import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String? id;
  String? title;
  String? author;
  int? length;
  String? cover;
  Timestamp? dateCompleted;
  String? ownerId;
  String? lenderId;
  List<String>? nbOfReaders;
  List<String>? nbOfFavorites;

  BookModel(
      {this.id,
      this.title,
      this.author,
      this.length,
      this.dateCompleted,
      this.ownerId,
      this.lenderId,
      this.nbOfReaders,
      this.nbOfFavorites,
      this.cover =
          "https://cdn1.sosav.fr/es/store/69972-large_default/frame-interno-oficial-wiko-Lenny.jpg"});

  BookModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    id = doc.id;
    title = doc.data()!["title"];
    author = doc.data()!["author"];
    length = doc.data()!["length"];
    cover = doc.data()!["cover"];
    dateCompleted = doc.data()!['dateCompleted'];
    ownerId = doc.data()!["ownerId"];
    lenderId = doc.data()!["lenderId"];
    nbOfReaders = doc.data()!["nbOfReaders"];
    nbOfFavorites = doc.data()!["nbOfFavorites"];
  }
}
