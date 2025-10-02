// import 'dart:convert';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:online_hunt_news/helpers&Widgets/loading.dart';
// import 'package:online_hunt_news/models/apiArticleModel.dart';
// import 'package:online_hunt_news/models/apiCategoriesModel.dart';
// import 'package:online_hunt_news/pages/aricleUploads/singleArticle.dart';
// import 'package:online_hunt_news/services/category_services.dart';
// import 'package:online_hunt_news/utils/cached_image.dart';
// import 'package:online_hunt_news/utils/next_screen.dart';
// import 'package:online_hunt_news/widgets/video_icon.dart';
// // import 'package:share/share.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../helpers&Widgets/key.dart';
// import '../models/dynamicLinks.dart';
// import '../models/like_model.dart';
// import '../utils/icons.dart';

// class UserArticleCardAlt extends StatelessWidget {
//   final ApiArticle apiArticle;
//   final String heroTag;
//   final LikeModel? likeId;
//   final bool? handlnigLike;
//   final bool? liked;
//   final VoidCallback? handleLoveCLick;
//   const UserArticleCardAlt({Key? key, required this.apiArticle, required this.heroTag, this.likeId, this.handlnigLike, this.liked, this.handleLoveCLick})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColorLight,
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
//         ),
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Flexible(
//                   flex: 5,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         apiArticle.title!,
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         maxLines: 4,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 10),
//                       Container(
//                         padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
//                         child: FutureBuilder(
//                           future: categoriesStream(apiArticle.categoryId),
//                           builder: (BuildContext context, AsyncSnapshot snapshot) {
//                             return snapshot.hasData
//                                 ? Text(
//                                     snapshot.data,
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//                                   )
//                                 : Loading();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   flex: 3,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                         child: Hero(
//                           tag: heroTag,
//                           child: CustomCacheImage(imageUrl: apiArticle.imageUrl, radius: 5.0, contentType: 'article', userId: apiArticle.userId),
//                         ),
//                       ),
//                       VideoIcon(contentType: apiArticle.videoUrl!.isEmpty ? 'Image' : 'video', iconSize: 40),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: <Widget>[
//                 Icon(CupertinoIcons.time, color: Colors.grey, size: 20),
//                 SizedBox(width: 5),
//                 Text(apiArticle.createdAt!, style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
//                 Spacer(),
//                 IconButton(
//                   icon: const Icon(FontAwesome.whatsapp, size: 22),
//                   onPressed: () async {
//                     _handleWhatsappShare();
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.share, size: 22),
//                   onPressed: () async {
//                     _handleContentShare();
//                   },
//                 ),
//                 handlnigLike == true ? Loading() : IconButton(icon: liked == true ? LoveIcon().bold : LoveIcon().normal, onPressed: handleLoveCLick),
//                 SizedBox(width: 3),
//                 // Text(d.loves.toString(),
//                 //     style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
//               ],
//             ),
//           ],
//         ),
//       ),
//       onTap: () => nextScreen(context, SingleArticle(article: apiArticle)),
//     );
//   }

//   _handleContentShare() async {
//     //     try {
//     //       await DynamicLinkService()
//     //           .createDynamicLink(apiArticle.id, apiArticle.categoryId!,
//     //               apiArticle.summary!.length >= 100 ? apiArticle.summary!.substring(0, 100) : apiArticle.summary!, apiArticle.title!, apiArticle.imageUrl!)
//     //           .then((value) => Share.share(
//     //                 '''${apiArticle.title!.length > 70 ? apiArticle.title!.substring(0, 70) : apiArticle.title}

//     // ${'click for more'.tr()}:${value.toString()}

//     // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}''',
//     //               ));
//     //     } catch (e) {
//     //       print(e.toString());
//     //     }
//   }

//   _handleWhatsappShare() async {
//     //     try {
//     //       await DynamicLinkService()
//     //           .createDynamicLink(apiArticle.id, apiArticle.categoryId!,
//     //               apiArticle.summary!.length >= 100 ? apiArticle.summary!.substring(0, 100) : apiArticle.summary!, apiArticle.title!, apiArticle.imageUrl!)
//     //           .then((value) => launch("https://wa.me?text=${'''${apiArticle.title!.length > 70 ? apiArticle.title!.substring(0, 70) : apiArticle.title}

//     // ${'click for more'.tr()}:${value.toString()}

//     // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}'''}"));
//     //     } catch (e) {
//     //       print(e.toString());
//     //     }
//   }

//   categoriesStream(categoryId) async {
//     List response = [];
//     List<ApiCategories> dummyList = [];
//     String language = await returnCategoryId();
//     List<ApiCategories> apiCategories = [];
//     String categoryName = '';
//     try {
//       await CategoryServices()
//           .getCategories('categories')
//           .then((value) {
//             response = jsonDecode(utf8.decode(value.bodyBytes));
//           })
//           .whenComplete(() {
//             response.forEach((element) {
//               dummyList.add(ApiCategories.fromJson(element));
//             });
//           });
//       dummyList.forEach((element) {
//         apiCategories.add(element);
//         // if (element.languageId == language) {

//         // }
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//     for (int i = 0; i < apiCategories.length; i++) {
//       if (apiCategories[i].categoyId == categoryId) {
//         // setState(() {
//         categoryName = apiCategories[i].categoryName!;
//         // });
//       }
//     }
//     return categoryName;
//   }
// }
