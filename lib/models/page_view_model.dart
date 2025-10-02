class PageViewModel {
  static const ID = 'id';
  static const POSTID = 'post_id';
  static const POSTUSERID = 'post_user_id';
  static const IPADDRESS = 'ip_address';
  static const USERAGENT = 'user_agent';
  static const REWARDAMOUNT = 'reward_amount';
  static const CREATEDAT = 'created_at';

  final String? id;
  final String? postId;
  final String? postUserId;
  final String? ipAddress;
  final String? userAgent;
  final String? rewardAmount;
  final String? createdAt;

  PageViewModel({
    this.id,
    this.postId,
    this.postUserId,
    this.ipAddress,
    this.userAgent,
    this.rewardAmount,
    this.createdAt,
  });

  factory PageViewModel.fromJson(dynamic _json) {
    return PageViewModel(
      id: _json[ID],
      postId: _json[POSTID],
      postUserId: _json[POSTUSERID],
      ipAddress: _json[IPADDRESS],
      userAgent: _json[USERAGENT],
      rewardAmount: _json[REWARDAMOUNT],
      createdAt: _json[CREATEDAT],
    );
  }


}
