import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/cards/iptv_item_card.dart';
import 'package:online_hunt_news/models/apiUserModel.dart';
import 'package:online_hunt_news/models/iptv_like_model.dart';
import 'package:online_hunt_news/models/iptv_model.dart';
import 'package:online_hunt_news/services/iptv_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../blocs/sign_in_bloc.dart';
import '../../helpers&Widgets/key.dart';
import '../../helpers&Widgets/loading.dart';
import '../../services/userServices.dart';
import '../../utils/sign_in_dialog.dart';

class IptvList extends StatefulWidget {
  IptvList({Key? key}) : super(key: key);

  @override
  State<IptvList> createState() => _IptvListState();
}

class _IptvListState extends State<IptvList> {
  IptvServices iptvServices = IptvServices();
  ScrollController scrollController = ScrollController();
  UserServices _userServices = UserServices();

  UserModel? apiUser;
  List<IptvModel> iptvs = [];
  bool gettingIptvs = true;
  bool _isLoadingMore = false;
  List<String> fileNames = [];

  String uid = '';
  List<bool> handlingLikes = [];
  List<bool> liked = [];
  List<IptvLikeModel> likeId = [];
  UserServices userServices = UserServices();
  // IptvServices iptvServices = IptvServices();
  @override
  void initState() {
    super.initState();
    getIptvs(false);
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange && _isLoadingMore == false) {
      print('loadingData');
      getIptvs(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => print(iptvs.length == fileNames.length), child: Text('iptv'.tr())),
      ),
      body: gettingIptvs == true
          ? Center(
              child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
            )
          : iptvs.isEmpty
          ? RefreshIndicator(
              onRefresh: () => getIptvs(true),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'no iptvs'.tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => getIptvs(true),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: iptvs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (BuildContext context, int index) {
                  IptvModel item = iptvs[index];
                  return IptvItemCard(
                    item: item,
                    handlnigLike: handlingLikes[index],
                    likeId: likeId[index],
                    liked: liked[index],
                    handleLoveCLick: () => handleLoveClick(index),
                  );
                },
              ),
            ),
    );
  }

  getIptvs(bool showToast) async {
    List response = [];
    fileNames.clear();
    iptvs.clear();
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid')!;
    try {
      if (mounted) {
        setState(() {
          gettingIptvs = true;
        });
      }

      await iptvServices
          .getIptvLinks('iptv')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
            // print(response);
          })
          .whenComplete(() {
            response.forEach((element) {
              print(element);
              iptvs.add(IptvModel.fromJson(element));
              videoThumbnail(IptvModel.fromJson(element).iptvUrl!);
            });

            getLikes();
            setState(() {
              gettingIptvs = false;
            });
          });
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          gettingIptvs = false;
        });
      }
    }
  }

  getLikes() async {
    // print(allArticles);
    liked.clear();
    likeId.clear();
    handlingLikes.clear();

    iptvs.forEach((element) {
      liked.add(false);
      likeId.add(IptvLikeModel());
      handlingLikes.add(false);
      getLikeStatus(iptvs.indexOf(element));
    });
  }

  handleLoveClick(int index) async {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    IptvModel iptvModel = iptvs[index];
    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      if (liked[index] == true) {
        // Fluttertoast.showToast(msg: 'msg');
        setState(() {
          handlingLikes[index] = true;
        });
        var params = {"api_key": "$apiKey", "id": "${likeId[index].id}"};
        print(params);
        await iptvServices.deleteIptvFav(params).whenComplete(() => getLikeStatus(index));
      } else {
        var params = {"api_key": "$apiKey", "user_id": "$uid", "iptv_id": "${iptvModel.id}"};
        setState(() {
          handlingLikes[index] = true;
        });
        iptvServices.createIptvFav(params).whenComplete(() => getLikeStatus(index));
      }
    }
  }

  getLikeStatus(int index) async {
    IptvModel apiArticle = iptvs[index];

    await iptvServices.getIptvFavorite(apiArticle.id, uid).then((value) {
      if (value.isNotEmpty) {
        // Fluttertoast.showToast(msg: 'msg');
        liked[index] = true;
        likeId[index] = value[0];
        handlingLikes[index] = false;
        setState(() {});
      } else {
        liked[index] = false;
        handlingLikes[index] = false;
        setState(() {});
      }
    });
  }

  Future videoThumbnail(String url) async {
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: url, // "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 70, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    return fileName;
  }

  Future getUserFollowing(String userId) async {
    // List<FollowingModel> followingList = await _userServices.getFollowing(userId, 'get_following'); //who is following you
    // return followingList.length.toString(); //who is following you
  }

  Future getAuthorProfile(String userId) async {
    UserModel _userDetails = await _userServices.userDetails(userId);
    print(_userDetails.email);
    return _userDetails;
  }
}
