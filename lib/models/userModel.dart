import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? image;
  String? name;

  UserModel({
    this.id,
    this.email,
    this.image,
    this.name,
  });

  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(
      id: d['uid'],
      email: d['email'],
      image: d['image url'],
      name: d['name'],
    );
  }
}
