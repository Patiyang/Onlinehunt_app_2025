class LikeModel {
  static const ID = 'id';
  static const POSTID = 'post_id';
  static const USERID = 'user_id';
  static const CATEGORYID = 'category_id';

  final String? id;
  final String? postId;
  final String? userId;
  final String? categoryId;
  LikeModel({this.id, this.postId, this.userId, this.categoryId});

  factory LikeModel.fromJson(dynamic _json) {
    return LikeModel(
      id: _json[ID],
      postId: _json[POSTID],
      userId: _json[USERID],
      categoryId: _json[CATEGORYID],
    );
  }
}
