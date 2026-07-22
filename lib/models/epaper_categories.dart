import 'package:flutter/material.dart';

class MagazineCategory {
  static const ID = 'id';
  static const NAME = 'name';
  static const SLUG = 'slug';
  static const PUBLICATIONCOUNT = 'publication_count';
  static const ISSUECOUNT = 'issue_count';

  final int id;
  final String name;
  final String slug;
  final int? publication_count;
  final int issue_count;

  MagazineCategory({required this.id, required this.name, required this.slug, this.publication_count, required this.issue_count});

  factory MagazineCategory.fromJson(Map<String, dynamic> json) {
    return MagazineCategory(
      id: json[ID],
      name: json[NAME] ?? '',
      slug: json[SLUG] ?? '',
      publication_count: json[PUBLICATIONCOUNT],
      issue_count: json[ISSUECOUNT],
    );
  }
}
