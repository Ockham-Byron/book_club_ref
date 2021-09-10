import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  Timestamp? accountCreated;
  String? pseudo;
  String? groupId;

  UserModel({
    this.uid,
    this.email,
  });

  UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    uid = doc.id;
    email = doc.data()!["email"];
    pseudo = doc.data()!["pseudo"];
    accountCreated = doc.data()!["accountCreated"];
    groupId = doc.data()!["groupId"];
  }
}
