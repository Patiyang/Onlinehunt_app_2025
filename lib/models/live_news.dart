class LiveNews {
  static const LIVENEWSID = 'id';
  static const LANGUAGEID = 'lang_id';
  static const TITLE = 'title';
  static const URL = 'url';
  static const KEYWORDS = 'keywords';
  static const DESCRIPTION = 'description';
  static const USERID = 'user_id';
  static const CREATEDAT = 'created_at';
  static const AVATAR = 'avatar';

  final int? liveNewsId;
  final int? languageId;
  final String? title;
  final String? url;
  final String? keywords;
  final String? description;
  final int? userId;
  final String avatar;

  LiveNews({this.liveNewsId, this.languageId, this.title, this.url, this.keywords, this.description, this.userId, required this.avatar});

  factory LiveNews.fromJson(dynamic _json) {
    return LiveNews(
      liveNewsId: _json[LIVENEWSID],
      title: _json[TITLE],
      url: _json[URL],
      languageId: _json[LANGUAGEID],
      keywords: _json[KEYWORDS]??'',
      description: _json[DESCRIPTION] ?? '',
      userId: _json[USERID],
      avatar: _json[AVATAR]??'',
    );
  }
}
