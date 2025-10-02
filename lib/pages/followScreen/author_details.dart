import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/authorModel.dart';
import 'package:online_hunt_news/models/followingModel.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cards/card4.dart';
import '../../models/apiUserModel.dart';
import '../../services/app_service.dart';
import '../../services/category_services.dart';

class AuthorDetails extends StatefulWidget {
  final Author apiUserModel;
  const AuthorDetails({Key? key, required this.apiUserModel}) : super(key: key);

  @override
  State<AuthorDetails> createState() => _AuthorDetailsState();
}

class _AuthorDetailsState extends State<AuthorDetails> {
  UserServices _userServices = UserServices();
  ApiUserModel? _userDetails;
  List<ApiArticle> _userArticles = [];
  List<ApiUserModel> authorFollowing = [];
  bool loadingArticles = true;
  bool loadingFollowing = true;
  bool loadingUserDetails = true;
  CategoryServices categoryServices = CategoryServices();
  String userId = '';
  String followers = '';
  String following = '';
  List<FollowingModel> followersList = [];
  List<FollowingModel> followingList = [];

  @override
  void initState() {
    // getAuthorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loadingUserDetails ? "---" : _userDetails!.userName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: .3)),
        actions: [
          IconButton(
            onPressed: () {
              AppService().openLinkWithCustomTab(context, 'https://onlinehunt.in/news/rss/author/${_userDetails!.slug}');
            },
            icon: Icon(FontAwesome.feed),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).primaryColorLight,
              alignment: Alignment.center,
              child: loadingUserDetails == true
                  ? Loading(
                      text: '${'please wait'.tr()}...',
                      spinkit: SpinKitRotatingCircle(color: Theme.of(context).primaryColor),
                    )
                  : FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _userDetails!.avatar!.isEmpty
                              ? CircleAvatar(radius: 50, backgroundColor: Colors.grey[300], child: Icon(Icons.person, size: 37))
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: CachedNetworkImageProvider(
                                    _userDetails!.avatar!.contains('https') ? _userDetails!.avatar! : "https://onlinehunt.in/news/${_userDetails!.avatar}",
                                  ),
                                ),
                          SizedBox(height: 10),
                          Text(_userDetails!.userName!, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3)),
                          Text(_userDetails!.email!, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3)),
                          SizedBox(height: 10),
                          userId == _userDetails!.id
                              ? SizedBox.shrink()
                              : loadingFollowing == true
                              ? Loading()
                              : GestureDetector(
                                  onTap: () async {
                                    SharedPreferences sp = await SharedPreferences.getInstance();
                                    print(sp.getString('uid'));
                                    if (followersList.isEmpty) {
                                      var parameters = {"api_key": "$apiKey", "following_id": "${_userDetails!.id}", "follower_id": "$userId"};
                                      _userServices.createFollow(parameters).then((value) {
                                        Map mapRes = jsonDecode(value.body);
                                        if (mapRes['status'] == true) {
                                          getUserFollowing();
                                        }
                                      });
                                    } else {
                                      followersList.any((element) {
                                        if (element.followerId == userId) {
                                          print('handle unfollow');
                                          var parameters = {"api_key": "$apiKey", "id": "${element.id}"};
                                          _userServices.deleteFollow(parameters).then((value) {
                                            Map mapRes = jsonDecode(value.body);
                                            if (mapRes['status'] == true) {
                                              getUserFollowing();
                                            }
                                          });
                                          return true;
                                        } else {
                                          var parameters = {"api_key": "$apiKey", "following_id": "${_userDetails!.id}", "follower_id": "$userId"};
                                          _userServices.createFollow(parameters).then((value) {
                                            Map mapRes = jsonDecode(value.body);
                                            if (mapRes['status'] == true) {
                                              getUserFollowing();
                                            }
                                          });
                                          print('handle follow');
                                          return false;
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).primaryColor),
                                    child: Text(
                                      followersList.any((element) => element.followerId == userId ? true : false) ? 'unfollow'.tr() : 'follow'.tr(),
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3, color: Colors.white),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 18),
                          Container(
                            width: MediaQuery.of(context).size.width * .75,
                            child: loadingFollowing == true
                                ? LoadingCard(height: 70)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        // onTap: () => nextScreen(context, HandleFollowing(operation: 'get_followers', apiUserModel: _userDetails!)),
                                        onTap: ()=>print('Followers Clicked'),
                                        child: Column(
                                          children: [
                                            Text('followers'.tr(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3)),
                                            Text(followers, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: .3)),
                                          ],
                                        ),
                                      ),
                                      Container(height: 50, width: 2, color: Theme.of(context).textTheme.titleMedium!.color),
                                      GestureDetector(
                                        // onTap: () => nextScreen(context, HandleFollowing(operation: 'get_following', apiUserModel: _userDetails!)),
                                        
                                        child: Column(
                                          children: [
                                            Text('following'.tr(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3)),
                                            Text(following, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: .3)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                child: _userArticles.isEmpty && loadingArticles == false
                    ? Text('no articles present'.tr(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: .3))
                    : ListView.separated(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        itemCount: loadingArticles == true ? 2 : _userArticles.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (loadingArticles == false) {
                            ApiArticle singleArticle = _userArticles[index];
                            return Card4(apiArticle: singleArticle, heroTag: '${singleArticle.id}', categoryName: 'snapshot.data');
                          } else {
                            return LoadingCard(height: 100);
                          }
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // getAuthorData() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   userId = sp.getString('uid')??'1';
  //   getAuthorProfile().whenComplete(() => getAuthorArticles());
  //   // getAuthorArticles();
  // }

  // Future getAuthorProfile() async {
  //   // _userDetails = await _userServices.userDetails(widget.apiUserModel.id!);
  //   loadingUserDetails = false;
  //   getUserFollowing();
  //   setState(() {});
  // }

  // Future getAuthorArticles() async {
  //   _userArticles = await _userServices.userArticles(_userDetails!.id);
  //   loadingArticles = false;
  //   Future.delayed(Duration(seconds: 2)).whenComplete(() {
  //     setState(() {});
  //   });
  // }

  Future getUserFollowing() async {
    followersList = [];
    followingList = [];
    setState(() {
      loadingFollowing = true;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('uid')!;

    // followersList = await _userServices.getFollowing(_userDetails!.id, 'get_followers'); //who you are following
    // followingList = await _userServices.getFollowing(_userDetails!.id, 'get_following'); //who is following you

    followers = followersList.length.toString(); //who you are following
    following = followingList.length.toString(); //who is following you
    setState(() {
      loadingFollowing = false;
    });
  }
}
