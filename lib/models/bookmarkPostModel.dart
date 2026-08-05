import 'package:online_hunt_news/models/FeedModel.dart';
import 'package:online_hunt_news/models/authorModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';

class BookmarkPostModel {
  final int id;
  final int post_id;
  final int user_id;
  final String saved_at;
  final String title;
  final String slug;
  final String summary;
  final String? content;
  final String? imageUrl;
  final String? video_url;
  final int? category_id;
  final int? lang_id;
  final String? post_created_at;
  final int? author_id;
  final String? post_url;
  final Author? author;
  final Category? category;
  final FeedModel? feedModel;

  BookmarkPostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    this.content,
    this.imageUrl,
    required this.post_url,
    required this.video_url,
    this.author,
    this.category,
    this.feedModel,
    required this.post_id,
    required this.user_id,
    required this.saved_at,
    this.category_id,
    this.lang_id,
    this.post_created_at,
    this.author_id,
  });

  factory BookmarkPostModel.fromJson(Map<String, dynamic> json) {
    return BookmarkPostModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      post_url: json['post_url'] ?? '',
      video_url: json['video_url'] ?? '',
      content: json['content'],
      imageUrl: json['image_url'],
      post_id: json['post_id'],
      user_id: json['user_id'],
      saved_at: json['saved_at'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      feedModel: json['feed'] != null ? FeedModel.fromJson(json['feed']) : null,
    );
  }

  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'title': title,
  //   'slug': slug,
  //   'summary': summary,
  //   'keywords': keywords,
  //   'content': content,
  //   'image_url': imageUrl,
  //   'post_url': post_url,
  //   'created_at': createdAt,
  //   'pageviews': pageviews,
  //   'comment_count': commentCount,
  //   'author': author?.toJson(),
  //   'category': category?.toJson(),
  // };
}
