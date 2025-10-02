import 'package:online_hunt_news/models/authorModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';

class PostModel {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final List<String> keywords;
  final String? content;
  final String? imageUrl;
  final String createdAt;
  final String? post_url;
  final int pageviews;
  final int commentCount;
  final Author? author;
  final Category? category;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.keywords,
    this.content,
    this.imageUrl,
    required this.createdAt,
    required this.post_url,
    required this.pageviews,
    required this.commentCount,
    this.author,
    this.category,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      post_url: json['post_url'],
      keywords: json['keywords'] != null ? List<String>.from(json['keywords']) : [],
      content: json['content'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      pageviews: json['pageviews'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'summary': summary,
    'keywords': keywords,
    'content': content,
    'image_url': imageUrl,
    'post_url': post_url,
    'created_at': createdAt,
    'pageviews': pageviews,
    'comment_count': commentCount,
    'author': author?.toJson(),
    'category': category?.toJson(),
  };
}
