
class ApiUserModel {
  final String? id;
  final String? userName;
  final String? slug;
  final String? email;
  final String? emailStatus;
  final String? token;
  final String? password;
  final String? role;
  final String? userType;
  final String? googleId;
  final String? facebookId;
  final String? vkId;
  final String? avatar;
  final String? status;
  final String? aboutMe;
  final String? facebookUrl;
  final String? twitterUrl;
  final String? instagramUrl;
  final String? pinterestUrl;
  final String? linkedInUrl;
  final String? vkUrl;
  final String? telegramUrl;
  final String? youtubeUrl;
  final String? lastSeen;
  final String? showEmail;
  final String? showRss;

  ApiUserModel(
      {this.id,
      this.userName,
      this.slug,
      this.email,
      this.emailStatus,
      this.token,
      this.password,
      this.role,
      this.userType,
      this.googleId,
      this.facebookId,
      this.vkId,
      this.avatar,
      this.status,
      this.aboutMe,
      this.facebookUrl,
      this.twitterUrl,
      this.instagramUrl,
      this.pinterestUrl,
      this.linkedInUrl,
      this.vkUrl,
      this.telegramUrl,
      this.youtubeUrl,
      this.lastSeen,
      this.showEmail,
      this.showRss});

  factory ApiUserModel.fromJson(_json) {
    return ApiUserModel(
      id: _json['id'],
      userName: _json['username'],
      email: _json['email'],
      googleId: _json['google_id'],
      facebookId: _json['facebook_id'],
      avatar: _json['avatar']??'',
      aboutMe: _json['about_me'],
      slug:_json['slug'],
    );
  }
}
