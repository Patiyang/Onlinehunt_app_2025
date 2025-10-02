// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chewie/chewie.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:online_hunt_news/blocs/ads_bloc.dart';
// import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
// import 'package:online_hunt_news/blocs/theme_bloc.dart';
// import 'package:online_hunt_news/models/apiArticleModel.dart';
// import 'package:online_hunt_news/models/custom_color.dart';
// import 'package:online_hunt_news/services/app_service.dart';
// import 'package:online_hunt_news/utils/cached_image.dart';
// import 'package:online_hunt_news/utils/sign_in_dialog.dart';
// import 'package:online_hunt_news/widgets/html_body.dart';
// import 'package:online_hunt_news/widgets/views_count.dart';
// // import 'package:share/share.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../helpers&Widgets/key.dart';
// import '../helpers&Widgets/loading.dart';
// import '../models/apiCategoriesModel.dart';
// import '../models/apiUserModel.dart';
// import '../models/dynamicLinks.dart';
// import '../models/followingModel.dart';
// import '../models/like_model.dart';
// import '../models/page_view_model.dart';
// import '../services/category_services.dart';
// import '../services/page_view_services.dart';
// import '../services/post_service.dart';
// import '../services/userServices.dart';
// import '../utils/icons.dart';
// import '../utils/loading_cards.dart';
// import '../utils/next_screen.dart';
// import 'followScreen/author_details.dart';

// class VideoArticleDetails extends StatefulWidget {
//   final ApiArticle? data;
//   final String? articleId;
//   final String categoryId;

//   const VideoArticleDetails({Key? key, required this.data, this.articleId, required this.categoryId}) : super(key: key);

//   @override
//   _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
// }

// class _VideoArticleDetailsState extends State<VideoArticleDetails> {
//   double rightPaddingValue = 140;
//   late YoutubePlayerController _controller;
//   PageViewServices _pageViewServices = PageViewServices();
//   List<PageViewModel> dummyList = [];
//   String pageViews = '';
//   bool liked = false;
//   String uid = '';
//   LikeModel? likeId;
//   bool handlnigLike = true;
//   UserServices userServices = new UserServices();
//   DynamicLinkService dynamicLinkService = new DynamicLinkService();

//   CategoryServices categoryServices = CategoryServices();
//   late ApiArticle article;
//   bool loadingArticle = true;
//   String category = '';
//   String webViewUserAgent = '';
//   ApiCategories? apiCategories;
//   PostServices postServices = new PostServices();
//   List<FollowingModel> followersList = [];
//   List<FollowingModel> followingList = [];
//   String userId = '';
//   late VideoPlayerController _videoPlayerController;
//   bool loadingFollowing = true;
//   UserServices _userServices = UserServices();
//   ChewieController? chewieController;
//   bool success = false;
//   bool loadingVideo = true;

//   // handleBookmarkClick() {
//   //   bool _guestUser = context.read<SignInBloc>().guestUser;

//   //   if (_guestUser == true) {
//   //     openSignInDialog(context);
//   //   } else {
//   //     context.read<BookmarkBloc>().onBookmarkIconClick(article.timestamp);
//   //   }
//   // }

//   _initInterstitialAds() {
//     final adb = context.read<AdsBloc>();
//     Future.delayed(Duration(milliseconds: 0)).then((value) {
//       if (adb.interstitialAdEnabled == true) {
//         context.read<AdsBloc>().loadAds();
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initInterstitialAds();
//     getArticle();
//     getLikeStatus();

//     Future.delayed(Duration(milliseconds: 100)).then((value) {
//       setState(() {
//         rightPaddingValue = 10;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     if (article.videoUrl!.contains('youtube')) {
//       _controller.dispose();
//     } else {
//       _videoPlayerController.dispose();
//       chewieController!.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   void deactivate() {
//     if (article.videoUrl!.contains('youtube')) {
//       _controller.pause();
//     } else {
//       _videoPlayerController.pause();
//       chewieController!.pause();
//     }
//     super.deactivate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sb = context.watch<SignInBloc>();
//     // final Article d = article;

//     return loadingArticle == true
//         ? Scaffold(
//             body: Center(
//               child: Loading(
//                 text: '${'please wait'.tr()}...',
//                 spinkit: SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
//               ),
//             ),
//           )
//         : !article.videoUrl!.contains('youtube')
//         ? _videoPlayerController.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _videoPlayerController.value.aspectRatio,
//                   child: Scaffold(
//                     body: detailsWidget(
//                       context,
//                       loadingVideo == true
//                           ? CircularProgressIndicator()
//                           : success == false
//                           ? Text('unable to load video'.tr())
//                           : Container(
//                               height: 270,
//                               width: MediaQuery.of(context).size.height,
//                               child: Chewie(controller: chewieController!),
//                             ),
//                     ),
//                   ),
//                 )
//               : Container()
//         : YoutubePlayerBuilder(
//             player: YoutubePlayer(
//               controller: _controller,
//               showVideoProgressIndicator: true,
//               thumbnail: CustomCacheImage(imageUrl: article.imageUrl, radius: 0, contentType: 'article', userId: userId),
//             ),
//             builder: (context, player) {
//               return Scaffold(body: detailsWidget(context, player));
//             },
//           );
//   }

//   Widget detailsWidget(BuildContext context, Widget player) {
//     return SafeArea(
//       bottom: false,
//       top: true,
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(child: player),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.keyboard_backspace, size: 22, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       FutureBuilder(
//                         future: userServices.userDetails(article.userId!),
//                         builder: (BuildContext context, AsyncSnapshot snapshot) {
//                           ApiUserModel user = snapshot.data;
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return LoadingCard(height: 40, width: 100);
//                           }
//                           if (snapshot.hasData) {
//                             return InkWell(
//                               onTap: () => nextScreen(context, AuthorDetails(apiUserModel: user)),
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () => print("https://onlinehunt.in/news/${user.avatar!}"),
//                                     child: user.avatar!.isEmpty
//                                         ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
//                                         : CircleAvatar(
//                                             radius: 15,
//                                             backgroundColor: Colors.grey[300],
//                                             backgroundImage: CachedNetworkImageProvider("https://onlinehunt.in/news/${user.avatar!}"),
//                                           ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Text(' ${user.userName!}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                                 ],
//                               ),
//                             );
//                           }
//                           if (snapshot.hasError) {
//                             print(snapshot.error.toString());
//                           }
//                           return SizedBox.shrink();
//                         },
//                       ),
//                       userId == article.userId
//                           ? SizedBox.shrink()
//                           : loadingFollowing == true
//                           ? Loading()
//                           : GestureDetector(
//                               onTap: () async {
//                                 SharedPreferences sp = await SharedPreferences.getInstance();
//                                 print(sp.getString('uid'));
//                                 print(followersList);
//                                 if (followersList.isEmpty) {
//                                   var parameters = {"api_key": "$apiKey", "following_id": "${article.userId}", "follower_id": "$userId"};
//                                   _userServices.createFollow(parameters).then((value) {
//                                     Map mapRes = jsonDecode(value.body);
//                                     if (mapRes['status'] == true) {
//                                       getUserFollowing();
//                                     }
//                                   });
//                                 } else {
//                                   followersList.any((element) {
//                                     if (element.followerId == userId) {
//                                       print('handle unfollow');
//                                       var parameters = {"api_key": "$apiKey", "id": "${element.id}"};
//                                       _userServices.deleteFollow(parameters).then((value) {
//                                         Map mapRes = jsonDecode(value.body);
//                                         if (mapRes['status'] == true) {
//                                           getUserFollowing();
//                                         }
//                                       });
//                                       return true;
//                                     } else {
//                                       var parameters = {"api_key": "$apiKey", "following_id": "${article.userId}", "follower_id": "$userId"};
//                                       _userServices.createFollow(parameters).then((value) {
//                                         Map mapRes = jsonDecode(value.body);
//                                         if (mapRes['status'] == true) {
//                                           getUserFollowing();
//                                         }
//                                       });
//                                       print('handle follow');
//                                       return false;
//                                     }
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).primaryColor),
//                                 child: Text(
//                                   followersList.any((element) => element.followerId == userId ? true : false) ? 'unfollow'.tr() : 'follow'.tr(),
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: context.watch<ThemeBloc>().darkTheme == false ? CustomColor().loadingColorLight : CustomColor().loadingColorDark,
//                         ),
//                         child: AnimatedPadding(
//                           duration: Duration(milliseconds: 1000),
//                           padding: EdgeInsets.only(left: 10, right: rightPaddingValue, top: 5, bottom: 5),
//                           child: Text(category, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                       Spacer(),
//                       article.postUrl == null
//                           ? Container()
//                           : IconButton(
//                               icon: const Icon(Feather.external_link, size: 22),
//                               onPressed: () => AppService().openLinkWithCustomTab(
//                                 context,
//                                 article.postUrl!.contains('https') ? article.postUrl! : 'https://${article.postUrl}',
//                               ),
//                             ),
//                       IconButton(
//                         icon: const Icon(FontAwesome.whatsapp, size: 22),
//                         onPressed: () async {
//                           _handleWhatsappShare();
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.share, size: 22),
//                         onPressed: () async {
//                           _handleContentShare();
//                         },
//                       ),
//                       handlnigLike == true
//                           ? Loading()
//                           : IconButton(
//                               icon: liked == true ? LoveIcon().bold : LoveIcon().normal,
//                               onPressed: () {
//                                 handleLoveClick();
//                               },
//                             ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: <Widget>[
//                       Icon(CupertinoIcons.time_solid, size: 18, color: Colors.grey),
//                       SizedBox(width: 5),
//                       Text(article.createdAt!.substring(0, 16), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12)),
//                     ],
//                   ),
//                   SizedBox(height: 5),
//                   Text(article.title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.6, wordSpacing: 1)),
//                   Divider(color: Theme.of(context).primaryColor, endIndent: 200, thickness: 2, height: 20),
//                   TextButton.icon(
//                     style: ButtonStyle(
//                       padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
//                       backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
//                       shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
//                     ),
//                     icon: Icon(Feather.message_circle, color: Colors.white, size: 20),
//                     label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
//                     onPressed: () {
//                       // nextScreen(context,CommentsPage(timestamp: d.timestamp));
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       //views feature
//                       ViewsCount(article: article),

//                       SizedBox(width: 20),

//                       // LoveCount(collectionName: 'contents', timestamp: d.timestamp),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   HtmlBodyWidget(htmlData: article.content!),
//                   SizedBox(
//                     height: 20,
//                     // ),
//                     // Container(
//                     //   child: RelatedArticles(
//                     //   category: d.category,
//                     //   timestamp: d.timestamp,
//                     //   replace: true,
//                     //   categoryId: ,
//                     //   )
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   initYoutube() async {
//     _controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(article.videoUrl!)!,
//       flags: YoutubePlayerFlags(autoPlay: false, mute: false, forceHD: false, loop: true, controlsVisibleAtStart: false, enableCaption: false),
//     );
//     _controller.play();
//   }

//   initOtherPlayer() async {
//     _videoPlayerController = VideoPlayerController.network(article.videoUrl!);
//     try {
//       await _videoPlayerController.initialize();

//       chewieController = ChewieController(videoPlayerController: _videoPlayerController, autoPlay: true, looping: true);
//       setState(() {
//         success = true;
//         loadingVideo = false;
//       });
//     } catch (e) {
//       print(e.toString());
//     }

//     // _videoPlayerController.initialize();
//     // _videoPlayerController.play();
//   }

//   _handleContentShare() async {
//     //     try {
//     //       await dynamicLinkService
//     //           .createDynamicLink(article.id, article.categoryId!, article.summary!.length >= 100 ? article.summary!.substring(0, 100) : article.summary!,
//     //               article.title!, article.imageUrl!)
//     //           .then((value) => Share.share(
//     //                 '''${article.title!.length > 70 ? article.title!.substring(0, 70) : article.title}

//     // ${'click for more'.tr()}:${value.toString()}

//     // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}''',
//     //               ));
//     //     } catch (e) {
//     //       print(e.toString());
//     //     }
//   }

//   _handleWhatsappShare() async {
//     //     try {
//     //       await dynamicLinkService
//     //           .createDynamicLink(article.id, article.categoryId!, article.summary!.length >= 100 ? article.summary!.substring(0, 100) : article.summary!,
//     //               article.title!, article.imageUrl!)
//     //           .then((value) => launch("https://wa.me?text=${'''${article.title!.length > 70 ? article.title!.substring(0, 70) : article.title}

//     // ${'click for more'.tr()}:${value.toString()}

//     // ${'${'download here'.tr()}: https://play.google.com/store/apps/details?id=com.onlinehunt.app'}'''}"));
//     //     } catch (e) {
//     //       print(e.toString());
//     //     }
//   }

//   handleLoveClick() {
//     bool _guestUser = context.read<SignInBloc>().guestUser;

//     if (_guestUser == true) {
//       openSignInDialog(context);
//     } else {
//       if (liked == true) {
//         setState(() {
//           handlnigLike = true;
//         });
//         var params = {"api_key": "$apiKey", "id": "${likeId!.id}"};
//         userServices.deleteFav(params).whenComplete(() => getLikeStatus());
//       } else {
//         var params = {"api_key": "$apiKey", "user_id": "$uid", "post_id": "${article.id}", "category_id": "${article.categoryId}"};
//         setState(() {
//           handlnigLike = true;
//         });
//         userServices.createFav(params).whenComplete(() => getLikeStatus());
//       }
//     }
//   }

//   getLikeStatus() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     uid = sp.getString('uid')!;
//     await userServices.getFavorite(article.id, uid).then((value) {
//       if (value.isNotEmpty) {
//         print(value);
//         liked = true;
//         likeId = value[0];
//         handlnigLike = false;
//         setState(() {});
//       } else {
//         liked = false;
//         handlnigLike = false;
//         setState(() {});
//       }
//     });
//   }

//   void getArticle() async {
//     if (widget.data != null) {
//       article = widget.data!;
//       if (article.videoUrl!.contains('youtube')) {
//         initYoutube();
//       } else {
//         initOtherPlayer();
//       }

//       List<ApiCategories> categories = await categoriesStream();
//       categories = await categoriesStream();
//       category = categories.where((element) => element.categoyId == article.categoryId ? true : false).first.categoryName!;

//       apiCategories = categories.where((element) => element.categoyId == article.categoryId ? true : false).first;
//       //  getApiData(mounted, apiCategories!, false);
//       getPageViews().whenComplete(() => createPageView());
//       setState(() {
//         loadingArticle = false;
//       });
//     } else {
//       print('getArticleBy');

//       try {
//         article = await getApiArticleById(widget.articleId!);
//         if (article.videoUrl!.contains('youtube')) {
//           initYoutube();
//         } else {
//           initOtherPlayer();
//         }
//         List<ApiCategories> categories = await categoriesStream();
//         categories = await categoriesStream();
//         category = categories.where((element) => element.categoyId == article.categoryId ? true : false).first.categoryName!;
//         apiCategories = categories.where((element) => element.categoyId == article.categoryId ? true : false).first;
//         getPageViews().whenComplete(() {
//           createPageView();
//         });
//         // getApiData(mounted, apiCategories!, false);
//         setState(() {
//           loadingArticle = false;
//         });
//       } catch (e) {
//         setState(() {
//           loadingArticle = false;
//         });
//         print(e.toString());
//         throw e;
//       }
//     }
//   }

//   Future getPageViews() async {
//     List response = [];
//     dummyList = [];

//     try {
//       await _pageViewServices
//           .getPageViews(article.id!)
//           .then((value) {
//             response = jsonDecode(value.body);
//           })
//           .whenComplete(() {
//             response.forEach((element) {
//               dummyList.add(PageViewModel.fromJson(element));
//             });
//           });
//       pageViews = dummyList.length.toString();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   createPageView() async {
//     print('the article id is ${article.id}');
//     getUserFollowing();
//     if (dummyList.any((element) => element.userAgent == webViewUserAgent ? true : false)) {
//       print(' present');
//     } else {
//       pageViews = '${int.parse(pageViews) + 1}'.toString();
//       var data = {
//         "api_key": "$apiKey",
//         "post_id": article.id,
//         "post_user_id": article.userId,
//         "ip_address": "ip",
//         "user_agent": webViewUserAgent,
//         "reward_amount": "0",
//         "created_at": DateTime.now().toString().substring(0, 19),
//       };
//       await _pageViewServices.createPageView(data).then((value) {
//         Map mapRes = jsonDecode(value.body);
//         print(mapRes['status']);
//         if (mapRes['status'] == true) {
//           updateArticlePv();
//         }
//       });
//       print('not present $pageViews');
//     }
//   }

//   initUserAgent() async {
//     await FkUserAgent.init();
//     webViewUserAgent = FkUserAgent.webViewUserAgent!;
//   }

//   Future<ApiArticle> getApiArticleById(String id) async {
//     List response = [];
//     List<ApiArticle> articles = [];
//     await postServices
//         .getAllPosts('single_post')
//         .then((value) {
//           response = jsonDecode(utf8.decode(value.bodyBytes));
//         })
//         .whenComplete(() {
//           for (int i = 0; i < response.length; i++) {
//             articles.add(ApiArticle.fromJson(response[i]));
//           }
//         });

//     return articles.where((element) => element.id == id ? true : false).first;
//   }

//   updateArticlePv() async {
//     var data = {
//       "api_key": "$apiKey",
//       "id": article.id,
//       "lang_id": article.langId,
//       "title": article.title,
//       "title_slug": article.titleSlug,
//       "title_hash": article.titleHash,
//       "keywords": article.keywords,
//       "summary": article.summary,
//       "content": article.content,
//       "category_id": article.categoryId,
//       "image_big": null,
//       "image_default": null,
//       "image_slider": null,
//       "image_mid": null,
//       "image_small": null,
//       "image_mime": article.imageMime,
//       "image_storage": "local",
//       "optional_url": article.optionalUrl,
//       "pageviews": pageViews,
//       "need_auth": article.need_auth,
//       "is_slider": article.is_slider,
//       "slider_order": article.slider_order,
//       "is_featured": article.is_featured,
//       "featured_order": article.featured_order,
//       "is_recommended": article.is_recommended,
//       "is_breaking": article.is_breaking,
//       "is_scheduled": article.is_scheduled,
//       "visibility": article.visibility,
//       "show_right_column": article.showRight,
//       "post_type": "article",
//       "video_path": "",
//       "video_storage": "local",
//       "image_url": article.imageUrl,
//       "video_url": article.videoUrl,
//       "video_embed_code": article.videoEmbedCode,
//       "user_id": article.userId,
//       "status": article.status,
//       "feed_id": article.feed_id,
//       "post_url": article.postUrl,
//       "show_post_url": article.show_post_url,
//       "image_description": article.imageDesc,
//       "show_item_numbers": article.show_item_numbers,
//       "updated_at": DateTime.now().toString().substring(0, 19),
//       "created_at": article.createdAt,
//     };

//     await postServices.updatePosts('posts', data).then((value) {
//       Map mapRes = jsonDecode(value.body);

//       if (value.statusCode == 200) {
//         if (mapRes['status'] == true) {
//           // Fluttertoast.showToast(msg: mapRes['message']);
//           print(mapRes['message']);
//         } else {
//           print(mapRes['message']);
//         }
//       } else {}
//     });
//   }

//   void getUserFollowing() async {
//     followersList = [];
//     followingList = [];
//     setState(() {
//       loadingFollowing = true;
//     });
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     userId = sp.getString('uid')!;

//     followersList = await _userServices.getFollowing(article.userId, 'get_followers'); //who you are following
//     // print(article.id);
//     // followingList = await _userServices.getFollowing(article.id, 'get_following'); //who is following you

//     // followers = followersList.length.toString(); //who you are following
//     // following = followingList.length.toString(); //who is following you
//     setState(() {
//       loadingFollowing = false;
//     });
//   }

//   categoriesStream() async {
//     List response = [];
//     List<ApiCategories> dummyList = [];
//     String language = await returnCategoryId();
//     List<ApiCategories> apiCategories = [];
//     try {
//       await categoryServices
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
//         if (element.languageId == language) {
//           apiCategories.add(element);
//         }
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//     return apiCategories;
//   }
// }
