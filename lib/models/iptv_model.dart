
class IptvModel {
  static const IPTVID = 'id';
  static const IPTVNAME = 'iptv_name';
  static const IPTVURL = 'iptv_url';
  static const IPTVLANGUAGE = 'lang_id';
  static const IPTVCREATEDAT = 'created_at';
  static const USERID = 'user_id';

  final String? id;
  final String? iptvName;
  final String? iptvUrl;
  final String? iptvLanguage;
  final String? iptvCreatedAT;
  final String? userId;
  IptvModel({
    this.id,
    this.iptvName,
    this.iptvUrl,
    this.iptvLanguage,
    this.iptvCreatedAT,
    this.userId
  });

  factory IptvModel.fromJson(snap) {
    // Map c = snap.data() as Map<dynamic, dynamic>;
    return IptvModel(
      id: snap[IPTVID],
      iptvName: snap[IPTVNAME],
      iptvUrl: snap[IPTVURL],
      iptvLanguage: snap[IPTVLANGUAGE],
      iptvCreatedAT: snap[IPTVCREATEDAT],
      userId: snap[USERID]
    );
  }
}
