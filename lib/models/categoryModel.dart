import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final int? langId;
  final String color;

  Category({required this.id, required this.name, required this.slug, this.description, this.langId, required this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description']??'',
      color: json['color']??'',
      langId: json['lang_id'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug, 'description': description, 'lang_id': langId};
}
