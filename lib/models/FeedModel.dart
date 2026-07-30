import 'package:flutter/material.dart';

class FeedModel {
  final int id;
  final String name;
  final String feedurl;

  FeedModel({required this.id, required this.name, required this.feedurl});

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(id: json['id'], name: json['name'] ?? '', feedurl: json['feed_url'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'feed_url': feedurl};
}
