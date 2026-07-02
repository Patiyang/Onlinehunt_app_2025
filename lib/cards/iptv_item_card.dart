import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_video_thumbnail/get_video_thumbnail.dart';
import 'package:get_video_thumbnail/index.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/api_live_news.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/models/iptv_like_model.dart';
import 'package:online_hunt_news/models/iptv_model.dart';
import 'package:online_hunt_news/utils/icons.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:share/share.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

import '../config/config.dart';
import '../helpers&Widgets/loading.dart';
import '../models/apiUserModel.dart';
import '../pages/iptv/iptv_video.dart';
import '../services/userServices.dart';
import '../utils/next_screen.dart';

class IptvItemCard extends StatelessWidget {
  final LiveNews? item;

  const IptvItemCard({Key? key, this.item}) : super(key: key);

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
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child:
                      // item!.avatar!.contains('http')
                      //     ?
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: '${HelperClass.avatarIp}${item!.avatar!}',
                          placeholder: (_, c) {
                            return ClipOval(child: Icon(Icons.person_off));
                          },
                          errorWidget: (_, c, o) {
                            return ClipOval(child: Icon(Icons.person_off));
                          },
                        ),
                      ),
                  // : CircleAvatar(
                  //     radius: 20,
                  //     backgroundColor: Theme.of(context).primaryColorDark,
                  //     child: Icon(Icons.person_off),
                  //   )
                ),
                SizedBox(width: 10),
                Text(item!.title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),

            SizedBox(height: 10),
            FutureBuilder(
              future: videoThumbnail(item!.url!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(File(snapshot.data), width: MediaQuery.of(context).size.width, height: 230, fit: BoxFit.cover),
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 22,
                    height: 150,
                    child: Image.asset(Config().splashIcon, fit: BoxFit.scaleDown),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future videoThumbnail(String url) async {
    // VideoThumbnail? videoThumbnail = VideoThumbnail();
    XFile? fileName = await VideoThumbnail.thumbnailFile(
      video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    return fileName.path;
  }

  Future getUserFollowing(String userId) async {
    // UserServices _userServices = UserServices();
    // List<FollowingModel> followingList = await UserServices().getFollowing(userId, 'get_following'); //who is following you
    return 3; //who is following you
  }

  Future getAuthorProfile(String userId) async {
    UserModel _userDetails = await UserServices().userDetails(userId);
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
