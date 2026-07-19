class PublicationModel {
  static const PUBLICATIONID = 'id';
  static const TITLE = 'title';
  static const SLUG = 'slug';
  static const DESCRIPTION = 'description';
  static const LOGO = 'logo';
  static const PUBLICATIONTYPE = 'publication_type';
  static const CATEGORYID = 'category_id';
  static const LANGUAGEID = 'lang_id';

  final int? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? logo;
  final String? publication_type;
  final int? category_id;
  final int? lang_id;

  PublicationModel({this.id, this.title, this.slug, this.description, this.logo, this.publication_type, this.category_id, this.lang_id});

  factory PublicationModel.fromJson(dynamic _json) {
    return PublicationModel(
      id: _json[PUBLICATIONID],
      title: _json[TITLE],
      slug: _json[SLUG],
      description: _json[DESCRIPTION],
      logo: _json[LOGO] ?? '',
      publication_type: _json[PUBLICATIONTYPE] ?? '',
      category_id: _json[CATEGORYID],
      lang_id: _json[LANGUAGEID],
    );
  }
}
