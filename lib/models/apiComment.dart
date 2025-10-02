import 'dart:convert';

ApiComment qrcodeFromJson(String str) => ApiComment.fromJson(json.decode(str));

// String qrcodeToJson(ApiComment data) => json.encode(data.toJson());

class ApiComment {
  ApiComment({
    this.id,
    this.parentId,
    this.postId,
    this.userId,
    this.email,
    this.name,
    this.comment,
    this.ipAddress,
    this.likeCount,
    this.status,
    this.createdAt,
  });

  final String? id;
  final String? parentId;
  final String? postId;
  final String? userId;
  final String? email;
  final String? name;
  final String? comment;
  final String? ipAddress;
  final String? likeCount;
  final String? status;
  final String? createdAt;

  factory ApiComment.fromJson(dynamic _json) => ApiComment(
        id: _json["id"] ?? '',
        parentId: _json["parent_id"] ?? '',
        postId: _json["post_id"] ?? '',
        userId: _json["user_id"] ?? '',
        email: _json["email"] ?? '',
        name: _json["name"] ?? '',
        comment: _json["comment"] ?? '',
        ipAddress: _json["ip_address"] ?? '',
        likeCount: _json["like_count"] ?? '',
        status: _json["status"] ?? '',
        createdAt:_json["created_at"]??'',
      );
}
