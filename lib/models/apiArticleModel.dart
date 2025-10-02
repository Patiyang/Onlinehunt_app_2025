import 'dart:convert';

ApiArticle qrcodeFromJson(String str) => ApiArticle.fromJson(json.decode(str));

// String qrcodeToJson(ApiArticle data) => json.encode(data.toJson());

class ApiArticle {
  ApiArticle({
    this.id,
    this.langId,
    this.title,
    this.titleSlug,
    this.titleHash,
    this.keywords,
    this.summary,
    this.content,
    this.categoryId,
    this.imageMime,
    this.imageStorage,
    this.optionalUrl,
    this.pageViews,
    this.imageUrl,
    this.videoUrl,
    this.videoEmbedCode,
    this.postUrl,
    this.showPostURL,
    this.createdAt,
    this.isFeatured,
    this.userId,
    this.imageDesc,
    this.visibility,
    this.showRight,
    this.need_auth,
    this.is_slider,
    this.slider_order,
    this.is_featured,
    this.featured_order,
    this.is_recommended,
    this.is_breaking,
    this.is_scheduled,
    this.status,
    this.feed_id,
    this.show_post_url,
    this.show_item_numbers,this.updated_at, 
  });

  final String? id;
  final String? langId;
  final String? title;
  final String? titleSlug;
  final String? titleHash;
  final String? keywords;
  final String? summary;
  final String? content;
  final String? categoryId;
  final String? imageMime;
  final String? imageStorage;
  final String? optionalUrl;
  final String? pageViews;
  final String? imageUrl;
  final String? videoUrl;
  final String? videoEmbedCode;
  final String? postUrl;
  final String? showPostURL;
  final String? createdAt;
  final String? isFeatured;
  final String? userId;
  final String? imageDesc;
  final String? visibility;
  final String? showRight;
  final String? need_auth;
  final String? is_slider;
  final String? slider_order;
  final String? is_featured;
  final String? featured_order;
  final String? is_recommended;
  final String? is_breaking;
  final String? is_scheduled;
  final String? feed_id;
  final String? status;
  final String? show_post_url;
  final String? show_item_numbers;
  final String? updated_at;

  factory ApiArticle.fromJson(dynamic _json) => ApiArticle(
        id: _json["id"] ?? '',
        langId: _json["lang_id"],
        title: _json["title"] ?? '',
        titleHash: _json["title_hash"],
        content: _json['content'],
        summary: _json['summary'],
        categoryId: _json['category_id'],
        imageUrl: _json['image_url'] ?? '',
        videoUrl: _json['video_url'] ?? '',
        createdAt: _json['created_at'],
        postUrl: _json['post_url'] ?? '',
        pageViews: _json['pageviews'],
        isFeatured: _json['is_featured'],
        userId: _json['user_id'],
        imageDesc: _json['image_description'] ?? "",
        keywords: _json['keywords'],
        visibility: _json['visibility'],
        showRight: _json['show_right_column'],
        need_auth: _json['need_auth'],
        is_slider: _json['is_slider'],
        slider_order: _json['slider_order'],
        is_featured: _json['is_featured'],
        featured_order: _json['featured_order'],
        is_recommended: _json['is_recommended'],
        is_breaking: _json['is_breaking'],
        is_scheduled: _json['is_scheduled'],
        status: _json['status'],
        imageMime: _json['image_mime'],
        imageStorage: _json['image_storage'],
        optionalUrl: _json['optional_url'],
        showPostURL: _json['show_post_url'],
        titleSlug: _json['title_slug'],
        videoEmbedCode: _json['video_embed_code'],
        feed_id: _json['feed_id'],
        show_item_numbers: _json['show_item_numbers'],
        show_post_url: _json['show_post_url']
      );

  // Map<String, dynamic> toJson() => {
  //       "error": error,
  //       "message": message,
  //       "qr": qr,
  //     };
}
