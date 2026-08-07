// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? image;
  String? first_name;
  String? last_name;
  String? about_me;
  String? auth_token;

  UserModel({required this.auth_token , required this.id, required this.email, required this.image, required this.first_name, required this.last_name, required this.about_me});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Map d = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(auth_token: json['auth_token'] ,
      id: json['id'],
      email: json['email'],
      image: json['avatar'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      about_me: json['about_me'],
    );
  }
}
