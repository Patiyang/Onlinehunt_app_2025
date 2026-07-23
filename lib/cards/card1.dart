// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
// import 'package:flutter_icons/flutter_icons.dart';

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
                      videoUrl: postModel!.video_url,
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: HelperClass().getCategoryColor(postModel!.category!.color)),
                    child: Text(
                      postModel!.category!.name,
                      // d.category!.toLowerCase().tr(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
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
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 22),
                        onPressed: () async {
                          HelperClass().handleWhatsappShare(context, postModel);
                        },
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.share, size: 22),
                        onPressed: () async {
                          HelperClass().handleContentShare(context, postModel);

                          // _handleContentShare(context);
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
}
