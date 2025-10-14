import 'package:cached_network_image/cached_network_image.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';

import 'package:online_hunt_news/models/authorModel.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/followScreen/author_details.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
// import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../models/like_model.dart';

class Card1 extends StatelessWidget {
  // final Article? d;
  // final ApiArticle? apiArticle;
  final PostModel? postModel;
  final Author? authorModel;
  // final String? categoryName;
  // final String categoryTitle;
  final String heroTag;
  final LikeModel? likeId;
  final bool? handlnigLike;
  final bool? liked;
  final VoidCallback? handleLoveCLick;
  const Card1({
    Key? key,
    required this.heroTag,
    // this.apiArticle,
    this.postModel,
    // this.categoryName,
    // required this.categoryTitle,
    this.likeId,
    this.handlnigLike,
    this.liked,
    this.handleLoveCLick,
    this.authorModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SharePlus share = SharePlus.instance;
    return InkWell(
      child: Container(
        // padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Hero(
                    tag: heroTag,
                    child: CustomCacheImage(
                      imageUrl: postModel!.imageUrl,
                      radius: 5.0,
                      contentType: 'article',
                      circularShape: false,
                      avatarUrl: "${HelperClass.avatarIp}${postModel!.author!.avatar}",
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     print('dcdc');
                //   },
                //   child: VideoIcon(
                //     contentType: apiArticle!.videoUrl!.isEmpty ? 'Image' : 'video',
                //     // contentType: d.contentType,
                //     iconSize: 40,
                //   ),
                // ),
              ],
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('dcdc');
                    },
                    child: Text(
                      // d.title!,
                      postModel!.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
                    child: Text(
                      postModel!.category!.name,
                      // d.category!.toLowerCase().tr(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      // FutureBuilder(
                      //   future: UserServices().userDetails(apiArticle!.userId!),
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //     ApiUserModel user = snapshot.data;
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return LoadingCard(height: 40, width: 100);
                      //     }
                      //     if (snapshot.hasData) {
                      //       return
                      //     }
                      //     if (snapshot.hasError) {
                      //       log(snapshot.error.toString());
                      //     }
                      //     return SizedBox.shrink();
                      //   },
                      // ),
                      InkWell(
                        onTap: () => nextScreen(context, AuthorDetails(apiUserModel: authorModel!)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("https://onlinehunt.in/news/${authorModel!.avatar!}"),
                              child: postModel!.author!.avatar!.isEmpty
                                  ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}${authorModel!.avatar!}"),
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(' ${authorModel!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
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
                      // handlnigLike == true ? Loading() : IconButton(icon: liked == true ? LoveIcon().bold : LoveIcon().normal, onPressed: handleLoveCLick),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => navigateToDetailsScreen(context, postModel!, heroTag, ''),
      // onTap: () => nextScreen(context, AuthorDetails(apiUserModel: authorModel!)),
    );
  }

  _handleContentShare() async {
    SharePlus share = SharePlus.instance;
    String deepLink = generateDeepLink(postModel!.id.toString());

    await share.share(ShareParams(text: deepLink));
    //     try {
    //       await DynamicLinkService()
    //           .createDynamicLink(apiArticle!.id, apiArticle!.categoryId!,
    //               apiArticle!.summary!.length >= 100 ? apiArticle!.summary!.substring(0, 100) : apiArticle!.summary!, apiArticle!.title!, apiArticle!.imageUrl!)
    //           .then((value) => Share.share(
    //                 '''${apiArticle!.title!.length > 70 ? apiArticle!.title!.substring(0, 70) : apiArticle!.title}

    // ${'click for more'.tr()}:${value.toString()}

    // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}''',
    //               ));
    //     } catch (e) {
    //       print(e.toString());
    //     }
  }

  _handleWhatsappShare() async {
    // launchUrl(  Uri.parse("https://wa.me?text=${'''${postModel!.title.length > 70 ? postModel!.title.substring(0, 70) : postModel!.title}'''}"));
    String deepLink = generateDeepLink(postModel!.id.toString());
    final encodedText = Uri.encodeComponent('Check this out: $deepLink');
    final whatsappUrl = 'https://wa.me/?text=$encodedText';

    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
    //     try {
    //       await DynamicLinkService()
    //           .createDynamicLink(apiArticle!.id, apiArticle!.categoryId!,
    //               apiArticle!.summary!.length >= 100 ? apiArticle!.summary!.substring(0, 100) : apiArticle!.summary!, apiArticle!.title!, apiArticle!.imageUrl!)
    //           .then((value) => launch("https://wa.me?text=${'''${apiArticle!.title!.length > 70 ? apiArticle!.title!.substring(0, 70) : apiArticle!.title}

    // ${'click for more'.tr()}:${value.toString()}

    // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}'''}"));
    //     } catch (e) {
    //       print(e.toString());
    //     }
  }

  String generateDeepLink(String postId) {
    return 'https://onlinehunt.in/news/p/$postId';
  }
}
