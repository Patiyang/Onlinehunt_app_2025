class IptvLikeModel {
  static const ID = 'id';
  static const IPTV = 'post_id';
  static const USERID = 'user_id';
  static const CATEGORYID = 'lang_id';

  final String? id;
  final String? iptvId;
  final String? userId;
  final String? langId;
  IptvLikeModel({this.id, this.iptvId, this.userId, this.langId});

  factory IptvLikeModel.fromJson(dynamic _json) {
    return IptvLikeModel(
      id: _json[ID],
      iptvId: _json[IPTV],
      userId: _json[USERID],
      langId: _json[CATEGORYID],
    );
  }
}
