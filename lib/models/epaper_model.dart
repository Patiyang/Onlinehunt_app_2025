import 'package:online_hunt_news/models/publications_model.dart';

class EpaperModel {
  static const ID = 'id';
  static const TITLE = 'title';
  static const ISSUEDATE = 'issue_date';
  static const COVERIMAGE = 'cover_image';
  static const SOURCETYPE = 'source_type';
  static const WEBSITEURL = 'website_url';
  static const PDFFILE = 'pdf_file';
  static const ISTODAY = 'is_today';
  static const TOTALVIEWS = 'total_views';
  static const PUBLICATION = 'publication';

  final int? id;
  final String? title;
  final String? issue_date;
  final String? cover_image;
  final String? source_type;
  final String? website_url;
  final String? pdf_file;
  final bool? is_today;
  final int? total_views;
  final PublicationModel? publication;

  EpaperModel({
    this.id,
    this.title,
    this.issue_date,
    this.cover_image,
    this.source_type,
    this.website_url,
    this.pdf_file,
    this.is_today,
    this.total_views,
    this.publication,
  });

  factory EpaperModel.fromJson(dynamic _json) {
    return EpaperModel(
      id: _json[ID],
      title: _json[TITLE],
      issue_date: _json[ISSUEDATE],
      cover_image: _json[COVERIMAGE]??'',
      source_type: _json[SOURCETYPE] ?? '',
      website_url: _json[WEBSITEURL] ?? '',
      pdf_file: _json[PDFFILE]??'',
      is_today: _json[ISTODAY],
      total_views: _json[TOTALVIEWS],
      publication: PublicationModel.fromJson(_json['publication'])
    );
  }
}
