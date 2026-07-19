class MediaModel {
  static const LIVENEWSID = 'id';
  static const FILENAME = 'file_name';
  static const FILEPATH = 'file_path';
  static const ISDOWNLOADABLE = 'is_downloadable';
  static const MEDIATYPE = 'media_type';
  static const STORAGE = 'storage';
  static const USERID = 'user_id';

  final int? id;
  final String? filename;
  final String? filepath;
  final int? isDownloadable;
  final String? mediatype;
  final String? storage;
  final String? userId;

  MediaModel({this.id, this.isDownloadable, this.filename, this.filepath, this.mediatype, this.storage, this.userId});

  factory MediaModel.fromJson(dynamic _json) {
    return MediaModel(
      id: _json[LIVENEWSID],
      filename: _json[FILENAME],
      filepath: _json[FILEPATH],
      isDownloadable: _json[ISDOWNLOADABLE],
      mediatype: _json[MEDIATYPE] ?? '',
      storage: _json[STORAGE] ?? '',
      userId: _json[USERID],
    );
  }
}
