import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_user_agent/flutter_user_agent.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/custom_color.dart';
import 'package:online_hunt_news/models/dynamicLinks.dart';
import 'package:online_hunt_news/models/like_model.dart';
import 'package:online_hunt_news/models/mobile_ads_model.dart';
import 'package:online_hunt_news/models/page_view_model.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/pages/comments.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/services/page_view_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/icons.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/utils/sign_in_dialog.dart';
//admob
//import 'package:online_hunt_news/widgets/banner_ad_fb.dart';      //fb ad
import 'package:online_hunt_news/widgets/html_body.dart';
import 'package:online_hunt_news/widgets/related_articles.dart';
// import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/followingModel.dart';
import '../services/category_services.dart';

class ArticleDetails extends StatefulWidget {
  final PostModel? post;
  // final String categoryId;
  final String? tag;
  final int? post_id;

  const ArticleDetails({Key? key, this.post, this.tag, required this.post_id}) : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> with AutomaticKeepAliveClientMixin {
  double rightPaddingValue = 140;
  DynamicLinkService dynamicLinkService = new DynamicLinkService();
  PostModel? post;
  bool loadingArticle = true;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostServices postServices = new PostServices();
  UserServices userServices = new UserServices();
  CategoryServices categoryServices = CategoryServices();
  String category = '';
  String webViewUserAgent = '';
  PageViewServices _pageViewServices = PageViewServices();
  List<PageViewModel> dummyList = [];
  String pageViews = '';
  bool liked = false;
  String uid = '';
  LikeModel? likeId;
  bool handlnigLike = true;
  Category? apiCategories;
  ScrollController _sc = new ScrollController();
  int _lastIndex = 0;
  int currentPage = 1;
  late List<Object> adsList = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  List<ApiArticle> _articlesData = [];
  List<FollowingModel> followersList = [];
  List<FollowingModel> followingList = [];
  String userId = '';

  bool loadingFollowing = true;
  UserServices _userServices = UserServices();
  MobileAdsaModel? _mobileAdsaModel;
  @override
  void initState() {
    initUserAgent();
    getArticle();
    // getLikeStatus();
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  initUserAgent() async {
    await FkUserAgent.init();
    webViewUserAgent = FkUserAgent.webViewUserAgent!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final innerScrollController = PrimaryScrollController.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: false,
        maintainBottomViewPadding: true,
        child: loadingArticle == true
            ? Center(
                child: Loading(
                  text: '${'please wait'.tr()}...',
                  spinkit: SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _customAppBar(post, context),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          // onTap: () => nextScreen(context, AuthorDetails(apiUserModel: post.author!)),
                                          onTap: () => print('${HelperClass.avatarIp}${post!.author!.avatar!}'),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => print('${HelperClass.avatarIp}${post!.author!.avatar!}'),
                                                child: post!.author!.avatar!.isEmpty
                                                    ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                                    : CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor: Colors.grey[300],
                                                        backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}${post!.author!.avatar!}"),
                                                      ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(' ${post!.author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        // FutureBuilder(
                                        //   future: userServices.userDetails(article.userId!),
                                        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        //     ApiUserModel user = snapshot.data;
                                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                                        //       return LoadingCard(height: 40, width: 100);
                                        //     }
                                        //     if (snapshot.hasData) {
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
                                        //                       backgroundImage: CachedNetworkImageProvider("https://onlinehunt.in/news/${user.avatar!}"),
                                        //                     ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             Text(' ${user.userName!}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                        //           ],
                                        //         ),
                                        //       );
                                        //     }
                                        //     if (snapshot.hasError) {
                                        //       print(snapshot.error.toString());
                                        //     }
                                        //     return SizedBox.shrink();
                                        //   },
                                        // ),
                                        userId == post!.author!.id
                                            ? SizedBox.shrink()
                                            /*   : loadingFollowing == true
                                            ? Loading() */
                                            : GestureDetector(
                                                onTap: () async {
                                                  // SharedPreferences sp = await SharedPreferences.getInstance();
                                                  // print(sp.getString('uid'));
                                                  // print(followersList);
                                                  // if (followersList.isEmpty) {
                                                  //   var parameters = {"api_key": "$apiKey", "following_id": "${article.userId}", "follower_id": "$userId"};
                                                  //   _userServices.createFollow(parameters).then((value) {
                                                  //     Map mapRes = jsonDecode(value.body);
                                                  //     if (mapRes['status'] == true) {
                                                  //       getUserFollowing();
                                                  //     }
                                                  //   });
                                                  // } else {
                                                  //   followersList.any((element) {
                                                  //     if (element.followerId == userId) {
                                                  //       print('handle unfollow');
                                                  //       var parameters = {"api_key": "$apiKey", "id": "${element.id}"};
                                                  //       _userServices.deleteFollow(parameters).then((value) {
                                                  //         Map mapRes = jsonDecode(value.body);
                                                  //         if (mapRes['status'] == true) {
                                                  //           getUserFollowing();
                                                  //         }
                                                  //       });
                                                  //       return true;
                                                  //     } else {
                                                  //       var parameters = {"api_key": "$apiKey", "following_id": "${article.userId}", "follower_id": "$userId"};
                                                  //       _userServices.createFollow(parameters).then((value) {
                                                  //         Map mapRes = jsonDecode(value.body);
                                                  //         if (mapRes['status'] == true) {
                                                  //           getUserFollowing();
                                                  //         }
                                                  //       });
                                                  //       print('handle follow');
                                                  //       return false;
                                                  //     }
                                                  //   });
                                                  // }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).primaryColor),
                                                  child: Text(
                                                    followersList.any((element) => element.followerId == userId ? true : false)
                                                        ? 'unfollow'.tr()
                                                        : 'follow'.tr(),
                                                    style: TextStyle(fontWeight: FontWeight.normal, letterSpacing: .3, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),

                                    Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: context.watch<ThemeBloc>().darkTheme == false
                                                ? CustomColor().loadingColorLight
                                                : CustomColor().loadingColorDark,
                                          ),
                                          child: AnimatedPadding(
                                            duration: Duration(milliseconds: 1000),
                                            padding: EdgeInsets.only(left: 10, right: rightPaddingValue, top: 5, bottom: 5),
                                            child: Text(post!.category!.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                        Spacer(),
                                        post!.post_url == null
                                            ? Container()
                                            : IconButton(
                                                icon: const Icon(Feather.external_link, size: 22),
                                                onPressed: () => AppService().openLinkWithCustomTab(
                                                  context,
                                                  post!.post_url!.contains('https') ? post!.post_url! : 'https://${post!.post_url}',
                                                ),
                                              ),
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
                                        // handlnigLike == true
                                        //     ? Loading()
                                        //     : IconButton(
                                        //         icon: liked == true ? LoveIcon().bold : LoveIcon().normal,
                                        //         onPressed: () {
                                        //           handleLoveClick();
                                        //         },
                                        //       ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Icon(CupertinoIcons.time_solid, size: 18, color: Colors.grey),
                                        SizedBox(width: 5),
                                        Text(post!.createdAt.substring(0, 16), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(post!.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: -0.6, wordSpacing: 1)),
                                    Divider(color: Theme.of(context).primaryColor, endIndent: 200, thickness: 2, height: 20),
                                    TextButton.icon(
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
                                        backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                                        shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                                      ),
                                      icon: Icon(Feather.message_circle, color: Colors.white, size: 20),
                                      label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
                                      onPressed: () {
                                        nextScreen(context, CommentsPage(articleId: post!.id.toString()));
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        //views feature
                                        Text(
                                          post!.pageviews.toString(),
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
                                        ),
                                        SizedBox(width: 20),

                                        // LoveCount(collectionName: 'contents', timestamp: article.createdAt),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    HtmlBodyWidget(htmlData: post!.content!),
                                    // Text(article.description!),
                                    SizedBox(height: 10),
                                    // context.watch<AdsBloc>().bannerAdEnabled == false ? Container() : BannerAdAdmob(), //admob
                                    // CustomMobileAd.getBannerAd(context, _mobileAdsaModel!),
                                    SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        TextButton.icon(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
                                            backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                                            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                                          ),
                                          icon: Icon(Feather.message_circle, color: Colors.white, size: 20),
                                          label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
                                          onPressed: () {
                                            nextScreen(context, CommentsPage(articleId: post!.id.toString()));
                                          },
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
                                        /*     handlnigLike == true
                                            ? Loading()
                                            :  */
                                        IconButton(
                                          icon: liked == true ? LoveIcon().bold : LoveIcon().normal,
                                          onPressed: () {
                                            // handleLoveClick();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: RelatedArticles(
                                  sc: innerScrollController,
                                  category: apiCategories,
                                  timestamp: post!.createdAt,
                                  replace: true,
                                  post: post,
                                  categoryId: post!.category!.id.toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // -- Banner ads --

                  // : BannerAdFb()    //fb
                ],
              ),
      ),
    );
  }

  SliverAppBar _customAppBar(PostModel? article, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 270,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.tag == null
            ? CustomCacheImage(imageUrl: article!.imageUrl, radius: 0.0)
            : Hero(
                tag: widget.tag!,
                child: GestureDetector(
                  onTap: () => print(article.imageUrl),
                  child: CustomCacheImage(imageUrl: article!.imageUrl, radius: 0.0),
                ),
              ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_backspace, size: 22, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // actions: <Widget>[
      //   article.sourceUrl == null
      //       ? Container()
      //       : IconButton(
      //           icon: const Icon(Feather.external_link, size: 22, color: Colors.white),
      //           onPressed: () => AppService().openLinkWithCustomTab(context, article.sourceUrl!),
      //         ),
      //   IconButton(u
      //     icon: const Icon(Icons.share, size: 22, color: Colors.white),
      //     onPressed: () {
      //       _handleShare();
      //     },
      //   ),
      //   SizedBox(
      //     width: 5,
      //   )
      // ],
    );
  }

  _handleContentShare() async {
    SharePlus share = SharePlus.instance;
    String deepLink = generateDeepLink(post!.id.toString());

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
    String deepLink = generateDeepLink(post!.id.toString());
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

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid =
        '${post!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS =
        '${post!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    if (Platform.isAndroid) {
      // Share.share(_shareTextAndroid);
      SharePlus.instance.share(ShareParams(text: _shareTextAndroid));
    } else {
      SharePlus.instance.share(ShareParams(text: _shareTextiOS));
    }
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      print('love clicked');
      // if (liked == true) {
      //   setState(() {
      //     handlnigLike = true;
      //   });
      //   var params = {"api_key": "$apiKey", "id": "${likeId!.id}"};
      //   print(params);
      //   userServices.deleteFav(params).whenComplete(() => getLikeStatus());
      // } else {
      //   var params = {"api_key": "$apiKey", "user_id": "$uid", "post_id": "${post.id}", "category_id": "${widget.categoryId}"};
      //   setState(() {
      //     handlnigLike = true;
      //   });
      //   userServices.createFav(params).whenComplete(() => getLikeStatus());
      // }
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      print('love clicked');

      // context.read<BookmarkBloc>().onBookmarkIconClick(post.createdAt);
    }
  }

  // Future<Article> getSrticleById(String? id) async => await firestore.collection('contents').doc(id).get().then((doc) {
  //   return Article.fromFirestore(doc);
  // });

  // Future<ApiUserModel> getUserById(String id) async {
  //   List response = [];
  //   List<ApiUserModel> articles = [];
  //   await postServices
  //       .getPosts('users')
  //       .then((value) {
  //         response = jsonDecode(utf8.decode(value.bodyBytes));
  //       })
  //       .whenComplete(() {
  //         for (int i = 0; i < response.length; i++) {
  //           articles.add(ApiUserModel.fromJson(response[i]));
  //         }
  //       });

  //   return articles.where((element) => element.id == id ? true : false).first;
  // }

  Future<PostModel> getApiArticleById(int id) async {
    Map<String, dynamic> response = {};
    // List<ApiArticle> articles = [];
    await postServices
        .getPost(id)
        .then((value) {
          response = jsonDecode(value.body);
        })
        .whenComplete(() {
          post = PostModel.fromJson(response['data']);
        });

    return post!;
  }

  getArticle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid') ?? '0';
    // await AdServices().getMobileAds('1', adspace: 'post_detail_ad').then((value) {
    //   _mobileAdsaModel = value[0];
    // });
    // if (widget.post != null) {
    // article = widget.data!;

    // List<ApiCategories> categories = await categoriesStream();
    // categories = await categoriesStream();
    // category = categories.where((element) => element.categoyId == article.categoryId ? true : false).first.categoryName!;

    // apiCategories = categories.where((element) => element.categoyId == article.categoryId ? true : false).first;
    // //  getApiData(mounted, apiCategories!, false);
    // // getPageViews().whenComplete(() => createPageView());
    // setState(() {
    //   loadingArticle = false;
    // });
    // } else {
    print('getArticleBy');
    // await AdServices()
    //     .getMobileAds('1', adspace: 'post_detail_ad')
    //     .then((value) {
    //       _mobileAdsaModel = value[0];
    //     })
    //     .catchError((onError) {
    //       Exception('the error is $onError');
    //     });
    try {
      post = await getApiArticleById(widget.post_id!);
      apiCategories = post!.category!;
      setState(() {
        loadingArticle = false;
      });
    } catch (e) {
      setState(() {
        loadingArticle = false;
      });
      print(e.toString());
      throw e;
    }
    // }
  }

  // categoriesStream() async {
  //   List response = [];
  //   List<ApiCategories> dummyList = [];
  //   int language = await returnCategoryId();
  //   List<ApiCategories> apiCategories = [];
  //   try {
  //     await categoryServices
  //         .getCategories()
  //         .then((value) {
  //           response = jsonDecode(utf8.decode(value.bodyBytes));
  //         })
  //         .whenComplete(() {
  //           response.forEach((element) {
  //             dummyList.add(ApiCategories.fromJson(element));
  //           });
  //         });
  //     dummyList.forEach((element) {
  //       if (element.languageId == language) {
  //         apiCategories.add(element);
  //       }
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return apiCategories;
  // }

  // getdImage(String? avatar) {
  //   String path = "${HelperClass.baseUrl}$avatar";
  //   print(path);
  //   Fluttertoast.showToast(msg: path);
  //   String localPath = '';
  //   // GallerySaver.saveImage(path).then((bool? success) {
  //   //   // print('Success add image $path');
  //   //   localPath = path;
  //   // }).catchError((onError) {
  //   //   print('Error add image $path');
  //   // });
  //   // Fluttertoast.showToast(msg: localPath);
  //   // return FileImage(File(localPath));
  // }

  // getLikeStatus() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   uid = sp.getString('uid') ?? '0';
  //   await userServices.getFavorite(widget.articleId, uid).then((value) {
  //     if (value.isNotEmpty) {
  //       print(value);
  //       liked = true;
  //       likeId = value[0];
  //       handlnigLike = false;
  //       setState(() {});
  //     } else {
  //       liked = false;
  //       handlnigLike = false;
  //       setState(() {});
  //     }
  //   });
  // }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoadingMore ? 1.0 : 00,
          child: GestureDetector(onTap: () => print(adsList.length), child: new Loading()),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getUserFollowing() async {
    followersList = [];
    followingList = [];
    setState(() {
      loadingFollowing = true;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('uid')!;

    // followersList = await _userServices.getFollowing(article.author!.id, 'get_followers'); //who you are following
    // print(article.id);
    // followingList = await _userServices.getFollowing(article.id, 'get_following'); //who is following you

    // followers = followersList.length.toString(); //who you are following
    // following = followingList.length.toString(); //who is following you
    setState(() {
      loadingFollowing = false;
    });
  }
}
