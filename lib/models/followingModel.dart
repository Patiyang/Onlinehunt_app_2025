class FollowingModel{
    static const ID = 'id';
  static const FOLLOWINGID = 'following_id';
  static const FOLLOWERID = 'follower_id';


  final String? id;
  final String? followingId;
  final String? followerId;
 

  FollowingModel( {
    this.id, this.followingId, this.followerId,

  });

  factory FollowingModel.fromJson(dynamic _json) {
    return FollowingModel(
      id: _json[ID],
      followerId:_json[FOLLOWERID],
      followingId: _json[FOLLOWINGID],
  
    );
  }

}