import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/video_icon.dart';
// import 'package:share/share.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/followScreen/author_details.dart';

class Card2 extends StatelessWidget {
  // final Article ?d;
  final PostModel? postModel;
  final String? categoryName;
  final String heroTag;
  // final LikeModel? likeId;
  // final bool? handlnigLike;
  final bool? liked;
  final VoidCallback? handleLoveCLick;
  const Card2({Key? key, required this.heroTag, this.categoryName, /* this.likeId, this.handlnigLike,*/ this.liked, this.handleLoveCLick, this.postModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        // padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Wrap(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: heroTag,
                    child: CustomCacheImage(
                      imageUrl: postModel!.imageUrl,
                      // contentType: 'article',
                      radius: 5.0,
                      // circularShape: false,
                    ),
                  ),
                ),
                VideoIcon(
                  contentType: 'Image',
                  // contentType: d.contentType,
                  iconSize: 80,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    postModel!.title,
                    // d.title!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15),
                  Text(
                    HtmlUnescape().convert(parse(postModel!.summary).documentElement!.text),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).secondaryHeaderColor),
                  ),
                  SizedBox(height: 13),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => nextScreen(context, AuthorDetails(apiUserModel: postModel!.author!)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("${HelperClass.avatarIp}${postModel!.author!.avatar!}"),
                              child: postModel!.author!.avatar!.isEmpty
                                  ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: CachedNetworkImageProvider('${HelperClass.avatarIp}${postModel!.author!.avatar!}'),
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(' ${postModel!.author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      // FutureBuilder(
                      //   future: UserServices().userDetails(postModel!.userId!),
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return LoadingCard(height: 40, width: 100);
                      //     }
                      //     if (snapshot.hasData) {
                      //       ApiUserModel user = snapshot.data;
                      //       return InkWell(
                      //         onTap: () => nextScreen(context, AuthorDetails(apiUserModel: user)),
                      //         child: Row(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () => print("https://onlinehunt.in/news/${user.avatar!}"),
                      //               child: user.avatar!.isEmpty
                      //                   ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                      //                   : CircleAvatar(
                      //                       radius: 15,
                      //                       backgroundColor: Colors.grey[300],
                      //                       backgroundImage: CachedNetworkImageProvider(
                      //                         user.avatar!.contains('https') ? user.avatar! : "https://onlinehunt.in/news/${user.avatar}",
                      //                       ),
                      //                     ),
                      //             ),
                      //             SizedBox(width: 10),
                      //             Text(' ${user.userName!}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      //           ],
                      //         ),
                      //       );
                      //     }
                      //     if (snapshot.hasError) {
                      //       log(snapshot.error.toString());
                      //     }
                      //     return Text('cdcdc');
                      //   },
                      // ),
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
                      // IconButton(icon: liked == true ? LoveIcon().bold : LoveIcon().normal, onPressed: handleLoveCLick),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => navigateToDetailsScreen(context, postModel!, heroTag, categoryName!),
      // onTap: ()=>print('card 2 tapped'),
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

  handleLoveClick() {}
}
