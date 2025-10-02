class ApiLanguages {
  static const LANGUAGEID = 'id';
  static const LANGUAGENAME = 'name';
  static const SHORTFORM = 'short_form';
  static const LANGUAGECODE = 'language_code';
  static const TEXTDIRECTION = 'text_direction';
  static const TEXTEDITORLANG = 'text_editor_lang';
  static const STATUS = 'status';
  static const LANGUAGEORDER = 'language_order';

  final String? languageId;
  final String? languageName;
  final String? shortForm;
  final String? languageCode;
  final String? textDirection;
  final String? textEditorLang;
  final String? status;
  final String? languageOrder;

  ApiLanguages({
    this.languageId,
    this.languageName,
    this.shortForm,
    this.languageCode,
    this.textDirection,
    this.textEditorLang,
    this.status,
    this.languageOrder,
  });

  factory ApiLanguages.fromJson(dynamic _json) {
    return ApiLanguages(
      languageId: _json[LANGUAGEID],
      languageName: _json[LANGUAGENAME],
      shortForm: _json[SHORTFORM],
      languageCode: _json[LANGUAGECODE],
      textDirection: _json[TEXTDIRECTION],
      textEditorLang: _json[TEXTEDITORLANG],
      status: _json[STATUS],
      languageOrder: _json[LANGUAGEORDER],
    );
  }
}
