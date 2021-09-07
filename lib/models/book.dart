import 'package:cloud_firestore/cloud_firestore.dart';

class OurBook {
  String? id;
  String? title;
  String? author;
  int? length;
  String cover;
  Timestamp? dateCompleted;

  OurBook(
      {this.id,
      this.title,
      this.author,
      this.length,
      this.dateCompleted,
      this.cover =
          "https://cdn1.sosav.fr/es/store/69972-large_default/frame-interno-oficial-wiko-Lenny.jpg"});
}
