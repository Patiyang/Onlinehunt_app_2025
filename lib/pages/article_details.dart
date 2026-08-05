import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/blocs/bookmark_bloc.dart';
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
import 'package:online_hunt_news/models/reactionItem.dart';
import 'package:online_hunt_news/pages/comments.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/services/bookmark_services.dart';
import 'package:online_hunt_news/services/follow_service.dart';
import 'package:online_hunt_news/services/page_view_services.dart';
import 'package:online_hunt_news/services/post_reaction_service.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/icons.dart';
import 'package:online_hunt_news/utils/interstitial_ads_page.dart';
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
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/followingModel.dart';
import '../services/category_services.dart';

class ArticleDetails extends StatefulWidget {
  final PostModel? post;
  // final String categoryId;
  final String? tag;
  final String? slug;
  final int? post_id;

  const ArticleDetails({Key? key, this.post, this.tag, required this.post_id, required this.slug}) : super(key: key);

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
  List<PageViewModel> dummyList = [];
  String pageViews = '';
  bool liked = false;
  String uid = '';
  LikeModel? likeId;
  bool handlnigLike = true;
  Category? apiCategories;
  late List<Object> adsList = [];
  List<FollowingModel> followersList = [];
  List<FollowingModel> followingList = [];
  String userId = '';
  bool is_following = false;
  bool loadingFollowing = true;
  // bool handle_follo
  FollowService followService = FollowService();
  PostReactionService postReactionService = PostReactionService();

  // FaIcon(FontAwesomeIcons.thumbsUp),

  List<Reactionitem> reactionItems = [
    Reactionitem(icon: FaIcon(FontAwesomeIcons.thumbsUp), reactionName: 'like', color: Colors.green),
    Reactionitem(icon: FaIcon(FontAwesomeIcons.thumbsDown), reactionName: 'dislike', color: Colors.amber),
    Reactionitem(icon: FaIcon(FontAwesomeIcons.faceAngry), reactionName: 'angry', color: Colors.red),
  ];
  Reactionitem? selectedReaction;

  BookmarkServices bookmarkService = BookmarkServices();
  bool save_status = false;
  bool loadingBm = true;
  @override
  void initState() {
    initUserAgent();
    getArticle();
    // getLikeStatus();
    // checkFollowing();
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  initUserAgent() async {
    final ua = await userAgent();
    final uaData = await userAgentData();
    final header = await userAgentClientHintsHeader();
    // await FkUserAgent.init();
    // webViewUserAgent = FkUserAgent.webViewUserAgent!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final innerScrollController = PrimaryScrollController.of(context);
    final sb = context.watch<SignInBloc>();
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
                                              post!.author!.avatar!.isEmpty
                                                  ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                                  : CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor: Colors.grey[300],
                                                      backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}${post!.author!.avatar!}"),
                                                    ),
                                              SizedBox(width: 10),
                                              Text(' ${post!.author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        // Text('${sb.uid!} ${post!.author!.id}'),
                                        Container(
                                          child: sb.uid == null
                                              ? SizedBox.shrink()
                                              : int.parse(sb.uid!) == post!.author!.id
                                              ? SizedBox.shrink()
                                              : loadingFollowing == true
                                              ? Loading()
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {});
                                                    is_following == false ? followUser() : unfollowUser();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).primaryColor),
                                                    child: Text(
                                                      is_following == true ? 'unfollow'.tr() : 'follow'.tr(),
                                                      style: TextStyle(fontWeight: FontWeight.normal, letterSpacing: .3, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            if (loadingBm == false) {
                                              setState(() {});
                                              save_status == false ? addBookMark() : removeBookMark();
                                            }
                                          },
                                          icon: loadingBm == true
                                              ? Loading()
                                              : save_status == true
                                              ? Icon(Icons.bookmark)
                                              : Icon(Icons.bookmark_outline),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: HelperClass().getCategoryColor(post!.category!.color) /* context.watch<ThemeBloc>().darkTheme == false
                                                ? CustomColor().loadingColorLight
                                                : CustomColor().loadingColorDark, */,
                                          ),
                                          child: AnimatedPadding(
                                            duration: Duration(milliseconds: 1000),
                                            padding: EdgeInsets.only(left: 10, right: rightPaddingValue, top: 5, bottom: 5),
                                            child: Text(
                                              post!.category!.name,
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        post!.post_url == null
                                            ? Container()
                                            : IconButton(
                                                icon: const FaIcon(FontAwesomeIcons.upRightFromSquare, size: 22),
                                                onPressed: () => AppService().openLinkWithCustomTab(
                                                  context,
                                                  post!.post_url!.contains('https') ? post!.post_url! : 'https://${post!.post_url}',
                                                ),
                                              ),
                                        IconButton(
                                          icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 22),
                                          onPressed: () async {
                                            // _handleWhatsappShare();
                                            HelperClass().handleWhatsappShare(context, post);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.share, size: 22),
                                          onPressed: () async {
                                            // _handleContentShare();
                                            HelperClass().handleContentShare(context, post);
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
                                    // TextButton.icon(
                                    //   style: ButtonStyle(
                                    //     padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
                                    //     backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                                    //     shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                                    //   ),
                                    //   icon: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 20),
                                    //   label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
                                    //   onPressed: () {
                                    //     nextScreen(context, CommentsPage(articleId: post!.id.toString()));
                                    //   },
                                    // ),
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        //views feature
                                        Icon(Icons.remove_red_eye, color: Theme.of(context).primaryColorLight), SizedBox(width: 10),

                                        Text(
                                          post!.pageviews.toString(),
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
                                        ),

                                        // LoveCount(collectionName: 'contents', timestamp: article.createdAt),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    HtmlBodyWidget(htmlData: post!.content!),
                                    // Text(article.description!),
                                    SizedBox(height: 10),

                                    post!.feedModel!.feedurl.isNotEmpty
                                        ? Card(
                                            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                                            shape: Border.all(style: BorderStyle.none),
                                            margin: const EdgeInsets.all(16),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: ExpansionTile(
                                                iconColor: Theme.of(context).primaryColor,
                                                shape: Border.all(style: BorderStyle.none),
                                                leading: const Icon(Icons.info_outline),
                                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                title: const Text('Disclaimer', style: TextStyle(fontWeight: FontWeight.bold)),
                                                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                                children: [Text('${'disclaimer'.tr()} ${post!.feedModel!.name}', textAlign: TextAlign.justify)],
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: reactionItems
                                          .map(
                                            (el) => IconButton.outlined(
                                              onPressed: () {
                                                if (sb.uid == null) {
                                                  Fluttertoast.showToast(msg: 'ractionsign'.tr());
                                                } else {
                                                  if (selectedReaction != null) {
                                                    if (el.reactionName == selectedReaction!.reactionName) {
                                                      removeReaction(el);
                                                    } else {
                                                      createReaction(el);
                                                    }
                                                  } else {
                                                    createReaction(el);
                                                  }
                                                }
                                              },
                                              icon: el.icon,

                                              color: selectedReaction == null
                                                  ? Theme.of(context).iconTheme.color
                                                  : selectedReaction!.reactionName == el.reactionName
                                                  ? el.color
                                                  : Theme.of(context).iconTheme.color,
                                              highlightColor: Theme.of(context).shadowColor,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    // context.watch<AdsBloc>().bannerAdEnabled == false ? Container() : BannerAdAdmob(), //admob
                                    // CustomMobileAd.getBannerAd(context, _mobileAdsaModel!),
                                    Row(
                                      children: <Widget>[
                                        TextButton.icon(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
                                            backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                                            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                                          ),
                                          icon: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 20),
                                          label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
                                          onPressed: () {
                                            nextScreen(context, CommentsPage(articleId: post!.id.toString()));
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
      automaticallyImplyLeading: true,
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
    String deepLink = generateDeepLink(post!.slug);

    await share.share(
      ShareParams(
        // uri: Uri.parse(deepLink),
        text:
            '''
📰 ${post!.title}

${HelperClass().limitSummary(post!.summary)}

${'click for more'.tr()}
$deepLink
''',
        subject: post!.title,
        title: post!.title,
        // previewThumbnail: XFile(Config().splashIcon,),
      ),
    );
  }

  _handleWhatsappShare() async {
    SharePlus share = SharePlus.instance;

    String deepLink = generateDeepLink(post!.slug);
    final message =
        '''
📰 ${post!.title}

${HelperClass().limitSummary(post!.summary)}

${'click for more'.tr()}
$deepLink
''';
    final whatsappUrl = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
    // await share.share(
    //   ShareParams(
    //     // uri: Uri.parse(deepLink),
    //     text: whatsappUrl,
    //     subject: postModel!.title,
    //     title: postModel!.title,
    //     // previewThumbnail: XFile(Config().splashIcon,),
    //   ),
    // );

    // final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  String generateDeepLink(String slug) {
    final languageCode = context.locale.languageCode;
    print('the code is $languageCode');
    if (languageCode == 'en') {
      return '${HelperClass.shareIp}$slug';
    }

    return '${HelperClass.shareIp}$languageCode/$slug';
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      print('love clicked');
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

  getArticle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid') ?? '0';
    // int user_id = int.parse(context.read<SignInBloc>().uid!);

    print('getArticleBy');

    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      print('The tick is: ${t.tick}');
      if (t.tick == 1) {
        t.cancel();
        try {
          post = await getApiArticleBySlug(widget.slug!);

          // if(user_id!=post)
          checkFollowing();
          checkReaction();
          checkBookMark();
          // print('''${post!.content}''');

          apiCategories = post!.category!;
          if (mounted) {
            setState(() {
              loadingArticle = false;
            });
          }
        } catch (e) {
          setState(() {
            loadingArticle = false;
          });
          print(e.toString());
          throw e;
        }
      }
    });
  }

  Future<PostModel> getApiArticleBySlug(String slug) async {
    Map<String, dynamic> response = {};
    // List<ApiArticle> articles = [];
    await postServices
        .getPostBySlug(slug)
        .then((value) {
          response = jsonDecode(value.body);
        })
        .whenComplete(() {
          post = PostModel.fromJson(response['data']);
        });

    return post!;
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

  checkFollowing() async {
    //  is_following = false;
    is_following = await followService.followStatus(post!.author!.id, context);
    // Fluttertoast.showToast(msg: is_following.toString());
    loadingFollowing = false;
    setState(() {});
    // return is_following;
  }

  followUser() async {
    loadingFollowing = true;
    await followService.followUser(post!.author!.id, post!.author!.username, context).then((val) {
      if (val == true) {
        is_following = true;
      }
    });
    setState(() {
      loadingFollowing = false;
    });
  }

  unfollowUser() async {
    loadingFollowing = true;
    await followService.unfollowUser(post!.author!.id, post!.author!.username, context).then((val) {
      if (val == true) {
        is_following = false;
      }
    });
    setState(() {
      loadingFollowing = false;
    });
  }

  checkReaction() async {
    //  is_following = false;
    // final sb = context.read<SignInBloc>();
    // if(sb.guestUser){}
    await postReactionService.postReactionValue(post!.id, context).then((val) {
      selectedReaction = reactionItems.where((test) => test.reactionName == val).firstOrNull;
    });
    // Fluttertoast.showToast(msg: is_following.toString());
    // loadingFollowing = false;
    setState(() {});
    // return is_following;
  }

  createReaction(Reactionitem reaction) async {
    await postReactionService.createReaction(post!.id, reaction.reactionName, context).then((val) {
      if (val == true) {
        selectedReaction = reactionItems.where((test) => test.reactionName == reaction.reactionName).first;
      }
      setState(() {});
    });
  }

  removeReaction(Reactionitem reaction) async {
    await postReactionService.removeReaction(post!.id, context).then((val) {
      if (val == true) {
        selectedReaction = null;
      }
      setState(() {});
    });
  }

  checkBookMark() async {
    await bookmarkService.bookmarkStatus(post!.id, context).then((val) {
      if (val == true) {
        save_status = true;
      }
    });
    loadingBm = false;
    setState(() {});
  }

  addBookMark() async {
    // save_status = null;
    loadingBm = true;
    await bookmarkService.addToBookmarks(post!.id, context).then((val) {
      if (val == true) {
        save_status = true;
      }
    });
    loadingBm = false;

    setState(() {});
  }

  removeBookMark() async {
    // save_status = null;
    final ub = context.read<SignInBloc>();

    loadingBm = true;
    await bookmarkService.removeBookmark(post!.id, context).then((val) {
      if (val == true) {
        save_status = false;

        context.read<BookmarkBloc>().onRefresh(mounted, int.parse(ub.uid!));
      }
    });
    loadingBm = false;
    setState(() {});
  }
}
