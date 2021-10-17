import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  Timestamp? accountCreated;
  String? pseudo;
  String? groupId;
  String pictureUrl =
      "https://digitalpainting.school/static/img/default_avatar.png";

  UserModel({
    this.uid,
    this.email,
    this.pseudo,
    this.accountCreated,
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
    pictureUrl = doc.data()!["pictureUrl"];
  }
}
