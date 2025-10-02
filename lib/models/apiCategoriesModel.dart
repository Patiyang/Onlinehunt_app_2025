class ApiCategories {
  static const CATEGORYID = 'id';
  static const LANGUAGEID = 'lang_id';
  static const CATEGORYNAME = 'name';
  static const SLUG = 'slug';
  // static const PARENTID = 'parent_id';
  static const DESCRIPTION = 'description';
  // static const KEYWORDS = 'keywords';
  // static const SHOWONMENU = 'show_on_menu';
  // static const CREATEDAT = 'created_at';

  final String? categoyId;
  final String? languageId;
  final String? categoryName;
  final String? slug;
  final String? description;
  // final String? parentId;
  // final String? keywords;
  // final String? showOnMenu;
  // final String? createdAt;

  ApiCategories({
    this.categoyId,
    this.languageId,
    this.categoryName,
    this.slug,
    this.description,
    // this.parentId,
    // this.keywords,
    // this.showOnMenu,
    // this.createdAt,
  });

  factory ApiCategories.fromJson(dynamic _json) {
    return ApiCategories(
      categoyId: _json[CATEGORYID],
      categoryName: _json[CATEGORYNAME],
      slug: _json[SLUG],
      languageId: _json[LANGUAGEID],
      // showOnMenu: _json[SHOWONMENU],
      // createdAt: _json[CREATEDAT],
      // parentId: _json[PARENTID],
    );
  }
}
