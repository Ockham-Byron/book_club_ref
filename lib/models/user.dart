import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String? userId;
  String? email;
  String? pseudo;
  Timestamp? accountCreated;
  String? groupId;

  OurUser(
      {this.userId,
      this.email,
      this.pseudo,
      this.accountCreated,
      this.groupId});
}
