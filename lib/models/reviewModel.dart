import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? userId;
  int? rating;
  String? review;

  ReviewModel({this.userId, this.rating, this.review});

  ReviewModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    userId = doc.id;
    rating = doc.data()!["rating"];
    review = doc.data()!["review"];
  }
}
