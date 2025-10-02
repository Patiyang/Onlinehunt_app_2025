import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/sign_in_bloc.dart';
import '../../helpers&Widgets/key.dart';
import '../../models/like_model.dart';
import '../../services/userServices.dart';
import '../../utils/sign_in_dialog.dart';

class AllArticles extends StatefulWidget {
  const AllArticles({Key? key}) : super(key: key);

  @override
  _AllArticlesState createState() => _AllArticlesState();
}

class _AllArticlesState extends State<AllArticles> {
  String uid = '';
  List<bool> handlingLikes = [];
  List<bool> liked = [];
  List<LikeModel> likeId = [];
  UserServices userServices = UserServices();
  List<ApiArticle> allArticles = [];
  int _lastIndex = 0;
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    getApiData(false);
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange && _isLoadingMore == false) {
      print('loadingData');
      getApiData(true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final uab = context.watch<AllUserArticlesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => getLikes(), child: Text('my uploads').tr()),
      ),
      body: _isLoading == true
          ? Loading(text: 'please wait'.tr())
          : RefreshIndicator(
              child: allArticles.length == 0
                  ? ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                        EmptyPage(icon: Feather.clipboard, message: 'no articles found'.tr(), message1: ''),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      itemCount: allArticles.length + 1,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 5);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        if (index == allArticles.length) {
                          return _buildProgressIndicator();
                        }
                        ApiArticle article = allArticles[index];
                        // return UserArticleCardAlt(
                        //   apiArticle: article,
                        //   heroTag: 'userArticle$index',
                        //   handlnigLike: handlingLikes[index],
                        //   likeId: likeId[index],
                        //   liked: liked[index],
                        //   handleLoveCLick: () => handleLoveClick(index),
                        // );
                        return SizedBox(height: 5);
                      },
                    ),
              onRefresh: () async => getApiData(false),
            ),
    );
  }

  Future getApiData(bool updateList) async {
    allArticles.clear();
    List response = [];
    List<ApiArticle> articles = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid')!;

    if (mounted) {
      try {
        // print('GETTING ALL USER ARTICLES');
        // Fluttertoast.showToast(msg: userIdd);
        await UserServices().userArticles(sp.getString('uid'), currentPage: currentPage).then((value) {
          articles = value;
          if (value.isNotEmpty) {
            _lastIndex = _lastIndex + 4;
          }
        });
        articles.forEach((element) {
          if (element.userId == uid) {
            allArticles.add(element);
          }
        });
        getLikes();
        _isLoading = false;
      } catch (e) {
        _isLoading = false;
        print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
      }
    }

    // _apiArticle = _apiArticle.reversed.toList();
  }

  getLikes() async {
    // print(allArticles);
    liked.clear();
    likeId.clear();
    handlingLikes.clear();

    allArticles.forEach((element) {
      liked.add(false);
      likeId.add(LikeModel());
      handlingLikes.add(false);
      getLikeStatus(allArticles.indexOf(element));
    });
  }

  handleLoveClick(int index) async {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    ApiArticle apiArticle = allArticles[index];
    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      if (liked[index] == true) {
        // Fluttertoast.showToast(msg: 'msg');
        setState(() {
          handlingLikes[index] = true;
        });
        var params = {"api_key": "$apiKey", "id": "${likeId[index].id}"};
        print(params);
        await userServices.deleteFav(params).whenComplete(() => getLikeStatus(index));
      } else {
        var params = {"api_key": "$apiKey", "user_id": "$uid", "post_id": "${apiArticle.id}", "category_id": "${apiArticle.categoryId}"};
        setState(() {
          handlingLikes[index] = true;
        });
        userServices.createFav(params).whenComplete(() => getLikeStatus(index));
      }
    }
  }

  getLikeStatus(int index) async {
    ApiArticle apiArticle = allArticles[index];

    await userServices.getFavorite(apiArticle.id, uid).then((value) {
      if (value.isNotEmpty) {
        // Fluttertoast.showToast(msg: 'msg');
        liked[index] = true;
        likeId[index] = value[0];
        handlingLikes[index] = false;
        setState(() {});
      } else {
        liked[index] = false;
        handlingLikes[index] = false;
        setState(() {});
      }
    });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(opacity: _isLoadingMore ? 1.0 : 0.0, child: new Loading()),
      ),
    );
  }
}
