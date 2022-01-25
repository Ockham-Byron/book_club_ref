import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? userId;
  int? rating;
  String? review;
  bool? favorite;

  ReviewModel({this.userId, this.rating, this.review, this.favorite = false});

  ReviewModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    userId = doc.id;
    rating = doc.data()!["rating"];
    review = doc.data()!["review"];
    favorite = doc.data()!["favorite"];
  }
}
