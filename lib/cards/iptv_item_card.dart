import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/models/iptv_like_model.dart';
import 'package:online_hunt_news/models/iptv_model.dart';
import 'package:online_hunt_news/utils/icons.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../config/config.dart';
import '../helpers&Widgets/loading.dart';
import '../models/apiUserModel.dart';
import '../pages/iptv/iptv_video.dart';
import '../services/userServices.dart';
import '../utils/next_screen.dart';

class IptvItemCard extends StatelessWidget {
  final IptvModel? item;
  final IptvLikeModel? likeId;
  final bool? handlnigLike;
  final bool? liked;
  final VoidCallback? handleLoveCLick;
  const IptvItemCard({Key? key, this.item, this.likeId, this.handlnigLike, this.liked, this.handleLoveCLick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => nextScreen(context, IptvVideo(iptvModel: item)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder(
                  future: getAuthorProfile(item!.userId!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      ApiUserModel user = snapshot.data;
                      return Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: user.avatar!.contains('http')
                            ? Image.network(user.avatar!, width: 40, fit: BoxFit.cover)
                            : ClipOval(child: Image.network('https://onlinehunt.in/news/${user.avatar!}', width: 40, fit: BoxFit.cover)),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: GestureDetector(
                        onTap: () => getAuthorProfile(item!.userId!),
                        child: Image.asset(Config().splashIcon, height: 40, width: 40, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                      future: getAuthorProfile(item!.userId!),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          ApiUserModel user = snapshot.data;
                          return Text(user.userName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
                        }
                        return Text(
                          '- -',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: getUserFollowing(item!.userId!),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data} ${'followers'.tr()}');
                        }
                        return Text('--');
                      },
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(FontAwesome.whatsapp, size: 22),
                  onPressed: () async {
                    _handleWhatsappShare();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, size: 22),
                  onPressed: () async {
                    _handleContentShare();
                  },
                ),
                handlnigLike == true ? Loading() : IconButton(icon: liked == true ? LoveIcon().bold : LoveIcon().normal, onPressed: handleLoveCLick),
                SizedBox(width: 3),
              ],
            ),
            SizedBox(height: 10),
            Text(item!.iptvName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            FutureBuilder(
              future: videoThumbnail(item!.iptvUrl!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(File(snapshot.data), width: MediaQuery.of(context).size.width - 22, height: 150, fit: BoxFit.cover),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: MediaQuery.of(context).size.width - 22,
                    height: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Center(child: Loading()),
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(Config().splashIcon, width: MediaQuery.of(context).size.width - 22, height: 150, fit: BoxFit.cover),
                );
              },
            ),
          ],
        ),
      ),
    );
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
    // UserServices _userServices = UserServices();
    // List<FollowingModel> followingList = await UserServices().getFollowing(userId, 'get_following'); //who is following you
    return 3; //who is following you
  }

  Future getAuthorProfile(String userId) async {
    ApiUserModel _userDetails = await UserServices().userDetails(userId);
    print(_userDetails.email);
    return _userDetails;
  }

  _handleContentShare() async {
    //     try {
    //       await DynamicLinkService().createDynamicLinkIptv(item!.id!, item!.iptvUrl!, item!.iptvName!).then((value) => Share.share(
    //             '''${item!.iptvName!.length > 70 ? item!.iptvName!.substring(0, 70) : item!.iptvName}

    // ${'click for more'.tr()}:${value.toString()}

    // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}''',
    //           ));
    //     } catch (e) {
    //       print(e.toString());
    //     }
  }

  _handleWhatsappShare() async {
    //     try {
    //       await DynamicLinkService()
    //           .createDynamicLinkIptv(item!.id!, item!.iptvUrl!, item!.iptvName!)
    //           .then((value) => launch("https://wa.me?text=${'''${item!.iptvName!.length > 70 ? item!.iptvName!.substring(0, 70) : item!.iptvName}

    // ${'click for more'.tr()}:${value.toString()}

    // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}'''}"));
    //     } catch (e) {
    //       print(e.toString());
    //     }
  }
}
