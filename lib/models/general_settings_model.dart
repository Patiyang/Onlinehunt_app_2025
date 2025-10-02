class GeneralSettingsModel {
  static const ID = 'id';
  static const POSTAPPROVAL = 'approve_added_user_posts';
  static const USERID = 'user_id';
  static const CATEGORYID = 'category_id';

  final String? id;
  final String? postApproval;
  // final String? userId;
  // final String? categoryId;
  GeneralSettingsModel({this.id, this.postApproval});

  factory GeneralSettingsModel.fromJson(dynamic _json) {
    return GeneralSettingsModel(
      id: _json[ID],
      postApproval: _json[POSTAPPROVAL],
      // userId: _json[USERID],
      // categoryId: _json[CATEGORYID],
    );
  }
}

class SettingsModel {
  static const ID = 'id';
  static const CONTACTEMAIL = 'contact_email';
  static const CONTACTPHONE = 'contact_phone';
  static const FACEBOOKURL = 'facebook_url';
  static const ABOUTSECTION = 'about_footer';
  static const PRIVACYPOLICY = 'privacy_policy';

  final String? id;
  final String? contactEmail;
  final String? contactPhone;
  final String? facebookUrl;
  final String? aboutFooter;
  final String? privacyPolicy;

  SettingsModel({this.facebookUrl, this.id, this.contactEmail, this.contactPhone, this.aboutFooter, this.privacyPolicy});

  factory SettingsModel.fromJson(dynamic _json) {
    return SettingsModel(
      id: _json[ID],
      contactEmail: _json[CONTACTEMAIL],
      contactPhone: _json[CONTACTPHONE],
      facebookUrl: _json[FACEBOOKURL],
      aboutFooter: _json[ABOUTSECTION],
      privacyPolicy: _json[PRIVACYPOLICY],
    );
  }
}
