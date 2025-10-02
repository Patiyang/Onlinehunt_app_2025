class MobileAdsaModel {
  static const ID = 'id';
  static const ADCODE = 'ad_code';

  static const ADMESSAGE = 'ad_message';
  static const ADSPACE = 'ad_space';
  static const ADVIEWS = 'ad_views';
  static const CATEGORYID = 'created_at';

  final String? id;
  final String? adCode;
  final String? adMessage;
  final String? adSpace;
  final String? adViews;
  final String? categoryId;

  MobileAdsaModel({
    this.id,
    this.adCode,
    this.adMessage,
    this.adSpace,
    this.adViews,
    this.categoryId,
  });

  factory MobileAdsaModel.fromJson(dynamic _json) {
    return MobileAdsaModel(
      id: _json[ID],
      adCode: _json[ADCODE],
      adMessage: _json[ADMESSAGE],
      adSpace: _json[ADSPACE],
      adViews: _json[ADVIEWS],
      categoryId: _json[CATEGORYID],
    );
  }
}
