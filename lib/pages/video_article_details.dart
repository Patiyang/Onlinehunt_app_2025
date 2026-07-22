import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/custom_color.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/sign_in_dialog.dart';
import 'package:online_hunt_news/widgets/html_body.dart';
import 'package:online_hunt_news/widgets/related_articles.dart';
// import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helpers&Widgets/loading.dart';
import '../models/dynamicLinks.dart';
import '../models/followingModel.dart';
import '../models/like_model.dart';
import '../models/page_view_model.dart';
import '../services/category_services.dart';
import '../services/page_view_services.dart';
import '../services/post_service.dart';
import '../services/userServices.dart';

class VideoArticleDetails extends StatefulWidget {
  final PostModel? data;
  final int? post_id;
  final String slug;
  // final String categoryId;

  const VideoArticleDetails({Key? key, required this.data, this.post_id, required this.slug}) : super(key: key);

  @override
  _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
}

class _VideoArticleDetailsState extends State<VideoArticleDetails> {
  double rightPaddingValue = 140;
  late YoutubePlayerController _controller;
  List<PageViewModel> dummyList = [];
  String pageViews = '';
  bool liked = false;
  bool isInitYOUTUBE = false;
  String uid = '';
  LikeModel? likeId;
  bool handlnigLike = true;
  UserServices userServices = new UserServices();
  DynamicLinkService dynamicLinkService = new DynamicLinkService();

  CategoryServices categoryServices = CategoryServices();
  late PostModel article;
  bool loadingArticle = true;
  String category = '';
  String webViewUserAgent = '';
  Category? apiCategories;
  PostServices postServices = new PostServices();
  List<FollowingModel> followersList = [];
  List<FollowingModel> followingList = [];
  String userId = '';
  late VideoPlayerController _videoPlayerController;
  bool loadingFollowing = true;
  ChewieController? chewieController;
  bool success = false;
  bool loadingVideo = true;

  // handleBookmarkClick() {
  //   bool _guestUser = context.read<SignInBloc>().guestUser;

  //   if (_guestUser == true) {
  //     openSignInDialog(context);
  //   } else {
  //     context.read<BookmarkBloc>().onBookmarkIconClick(article.timestamp);
  //   }
  // }

  _initInterstitialAds() {
    final adb = context.read<AdsBloc>();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      if (adb.interstitialAdEnabled == true) {
        context.read<AdsBloc>().loadAds();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initInterstitialAds();
    getArticle();
    // getLikeStatus();

    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    if (article.video_url!.contains('youtube')) {
      _controller.dispose();
    } else {
      _videoPlayerController.dispose();
      if (chewieController != null) {
        chewieController!.dispose();
      }
    }
    super.dispose();
  }

  @override
  void deactivate() {
    if (article.video_url!.contains('youtube')) {
      _controller.pause();
    } else {
      _videoPlayerController.pause();
      if (chewieController != null) {
        chewieController!.pause();
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    // final Article d = article;
    final innerScrollController = PrimaryScrollController.of(context);

    return Scaffold(
      body: loadingArticle == true
          ? Center(
              child: Loading(
                text: '${'please wait'.tr()}...',
                spinkit: SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
              ),
            )
          : article.video_url == null || article.video_url!.isEmpty
          ? Center(
              child: GestureDetector(
                onTap: () {
                  getArticle();
                },
                child: Loading(
                  text: '${'no video found'.tr()}...',
                  spinkit: SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
                ),
              ),
            )
          : !article.video_url!.contains('youtube')
          ? _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: detailsWidget(
                      context,
                      loadingVideo == true
                          ? CircularProgressIndicator()
                          : success == false
                          ? Text('unable to load video'.tr())
                          : Container(
                              height: 270,
                              width: MediaQuery.of(context).size.height,
                              child: Chewie(controller: chewieController!),
                            ),
                      innerScrollController,
                    ),
                  )
                : Container()
          : YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                thumbnail: YoutubePlayer(controller: _controller).thumbnail,
              ),
              builder: (context, player) {
                return detailsWidget(context, player, innerScrollController);
              },
            ),
      // : Container(child: Center(child: Text('unable to load video'.tr()))),
    );
  }

  Widget detailsWidget(BuildContext context, Widget player, innerScrollController) {
    return SafeArea(
      bottom: false,
      top: true,
      child: Column(
        children: [
          Stack(
            children: [
              Container(child: player),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_backspace, size: 22, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => print('AUTHOR DETAILS') /*  nextScreen(context, AuthorDetails(apiUserModel: user)) */,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("${HelperClass.avatarIp}${article.author!.avatar!}"),
                              child: article.author!.avatar!.isEmpty
                                  ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}${article.author!.avatar!}"),
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(' ${article.author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      userId == article.author!.id
                          ? SizedBox.shrink()
                          // : loadingFollowing == true
                          // ? Loading()
                          : GestureDetector(
                              onTap: () async {
                                print(_controller.value.metaData.title);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).primaryColor),
                                child: Text(
                                  followersList.any((element) => element.followerId == userId ? true : false) ? 'unfollow'.tr() : 'follow'.tr(),
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .3, color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: HelperClass().getCategoryColor(article.category!.color)),
                        child: AnimatedPadding(
                          duration: Duration(milliseconds: 1000),
                          padding: EdgeInsets.only(left: 10, right: rightPaddingValue, top: 5, bottom: 5),
                          child: Text(
                            article.category!.name,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer(),
                      article.post_url == null
                          ? Container()
                          : IconButton(
                              icon: const FaIcon(FontAwesomeIcons.upRightFromSquare, size: 22),
                              onPressed: () => AppService().openLinkWithCustomTab(
                                context,
                                article.post_url!.contains('https') ? article.post_url! : 'https://${article.post_url}',
                              ),
                            ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 22),
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
                      Text(article.createdAt.substring(0, 16), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(article.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.6, wordSpacing: 1)),
                  Divider(color: Theme.of(context).primaryColor, endIndent: 200, thickness: 2, height: 20),
                  TextButton.icon(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.only(left: 10, right: 10)),
                      backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                      shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                    ),
                    icon: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 20),
                    label: Text('comments', style: TextStyle(color: Colors.white)).tr(),
                    onPressed: () {
                      // nextScreen(context,CommentsPage(timestamp: d.timestamp));
                    },
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //views feature
                      Text(
                        article.pageviews.toString(),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      SizedBox(width: 20),

                      // LoveCount(collectionName: 'contents', timestamp: article.createdAt),
                    ],
                  ),
                  SizedBox(height: 20),
                  HtmlBodyWidget(htmlData: article.content!),
                  SizedBox(
                    height: 20,
                    // ),
                    // Container(
                    //   child: RelatedArticles(
                    //   category: d.category,
                    //   timestamp: d.timestamp,
                    //   replace: true,
                    //   categoryId: ,
                    //   )
                  ),
                  RelatedArticles(
                    sc: innerScrollController,
                    category: apiCategories,
                    timestamp: article.createdAt,
                    replace: true,
                    post: article,
                    categoryId: article.category!.id.toString(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
          article = PostModel.fromJson(response['data']);
        });

    return article;
  }

  void getArticle() async {
    print('getArticleBy');
    try {
      article = await getApiArticleBySlug(widget.slug);
      apiCategories = article.category!;

      if (article.video_url!.contains('youtube')) {
        initYoutube();
      } else {
        initOtherPlayer();
      }
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
  }

  initYoutube() async {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(article.video_url!)!,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false, forceHD: false, loop: true, controlsVisibleAtStart: false, enableCaption: false),
    );

    Timer.periodic(Duration(seconds: 1), (t) {});
    _controller.addListener(() {});
    // _controller.value.isReady
    //     ? _controller.play()
    //     : _controller.addListener(() {
    //         if (_controller.value.isReady) {
    //           _controller.play();
    //         }
    //       });
    // _controller.play();
  }

  initOtherPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(article.video_url!));
    try {
      await _videoPlayerController.initialize();

      chewieController = ChewieController(videoPlayerController: _videoPlayerController, autoPlay: true, looping: true);
      setState(() {
        success = true;
        loadingVideo = false;
      });
    } catch (e) {
      print(e.toString());
    }

    // _videoPlayerController.initialize();
    // _videoPlayerController.play();
  }

  _handleContentShare() async {
    SharePlus share = SharePlus.instance;
    String deepLink = generateDeepLink(article.slug);

    await share.share(
      ShareParams(
        // uri: Uri.parse(deepLink),
        text:
            '''
📰 ${article.title}

${HelperClass().limitSummary(article.summary)}

${'click for more'.tr()}
$deepLink
''',
        subject: article.title,
        title: article.title,
        // previewThumbnail: XFile(Config().splashIcon,),
      ),
    );
  }

  _handleWhatsappShare() async {
    SharePlus share = SharePlus.instance;

    String deepLink = generateDeepLink(article.slug);
    final message =
        '''
📰 ${article.title}

${HelperClass().limitSummary(article.summary)}

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

  initUserAgent() async {
    final ua = await userAgent();
    final uaData = await userAgentData();
    final header = await userAgentClientHintsHeader();
    // await FkUserAgent.init();
    // webViewUserAgent = FkUserAgent.webViewUserAgent!;
  }

  void getUserFollowing() async {
    followersList = [];
    followingList = [];
    setState(() {
      loadingFollowing = true;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('uid')!;

    setState(() {
      loadingFollowing = false;
    });
  }
}
