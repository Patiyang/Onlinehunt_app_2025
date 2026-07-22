import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/blocs/tab_index_bloc.dart';
import 'package:online_hunt_news/cards/card2.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/like_model.dart';
import 'package:online_hunt_news/models/metaModel.dart';
import 'package:online_hunt_news/models/mobile_ads_model.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:online_hunt_news/utils/sign_in_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/sign_in_bloc.dart';
import '../helpers&Widgets/key.dart';

import '../services/userServices.dart';

class CategoryTabGeneric extends StatefulWidget {
  final Category? apiCategory;
  final ScrollController? sc;
  CategoryTabGeneric({Key? key, this.sc, this.apiCategory}) : super(key: key);

  @override
  _CategoryTabGenericState createState() => _CategoryTabGenericState();
}

class _CategoryTabGenericState extends State<CategoryTabGeneric> with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostServices postServices = PostServices();
  CategoryServices categoryServices = CategoryServices();
  // List<Article> _data = [];
  List<PostModel> posts = [];

  List<Category> ddCategoriesList = [];
  Category? selectedSubCat;
  // List<ApiArticle> articles = [];
  int _lastIndex = 0;
  Metamodel? metaData;
  int currentPage = 1;
  int totalPages = 1;
  QuerySnapshot? rawData;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  late List<Object> adsList;
  late List<String> stringList;
  final tb = TabIndexBloc().tabIndex;
  ScrollController scrollController = ScrollController();
  List<MobileAdsaModel> mobileAds = [];
  UserServices userServices = UserServices();
  String uid = '';
  List<bool> handlingLikes = [];
  List<bool> liked = [];
  List<LikeModel> likeId = [];
  @override
  void initState() {
    // categoriesStream();
    getApiData(mounted, false);
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange && _isLoadingMore == false) {
      print('loadingData');
      if (metaData!.total == posts.length) {
        print('no more data');
        return;
      } else {
        getApiData(mounted, true);
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading == true
        ? Loading(text: 'please wait'.tr())
        : RefreshIndicator(
            onRefresh: () => getApiData(mounted, false),
            child: Stack(
              children: [
                posts.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                          EmptyPage(icon: Icons.search, message: 'no articles found'.tr(), message1: ''),
                        ],
                      )
                    : ListView.separated(
                        controller: scrollController,
                        key: PageStorageKey(widget.apiCategory!.name),
                        padding: EdgeInsets.all(15),
                        itemCount: posts.length + 1,
                        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15),
                        itemBuilder: (_, int index) {
                          if (index == posts.length) {
                            return _buildProgressIndicator();
                          }
                          return Card2(
                            categoryName: selectedSubCat == null ? '--' : selectedSubCat!.name,
                            heroTag: 'tab1$index',
                            postModel: posts[index],
                            // apiArticle: adsList[index] as ApiArticle,
                            // handlnigLike: handlingLikes[index],
                            // likeId: likeId[index],
                            liked: false,
                            handleLoveCLick: () => handleLoveClick(index),
                          );
                        },
                      ),

                posts.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 25,
                          width: double.infinity,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                          child: Center(
                            child: Text(
                              '${'page'.tr()} ${metaData!.currentPage} ${'of'.tr()} ${metaData!.totalPages}',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
  }

  getApiData(bool mounted, bool updateList) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid') ?? '';
    // print();
    if (mounted && updateList == false) {
      setState(() {
        _isLoading = true;
        currentPage = 1;
        totalPages = 1;
        posts = [];
        mobileAds = [];
        liked = [];
        likeId = [];
        handlingLikes = [];
      });
    }
    if (mounted && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    Map<String, dynamic> response = {};

    try {
      await categoryServices
          .getCategoriesWithPosts(widget.apiCategory!.id, currentPage)
          .then((value) {
            response = jsonDecode(value.body);
            print(response['posts'].length);
          })
          .whenComplete(() {
            for (int i = 0; i < response['posts'].length; i++) {
              posts.add(PostModel.fromJson(response['posts'][i]));
            }
            metaData = Metamodel.fromJson(response['meta']);
            totalPages = metaData!.totalPages;
            _lastIndex = _lastIndex + 4;
          });

      if (mounted && updateList == false) {
        // handlingLikes.add(false);
        // liked.add(false);
        // likeId.add(LikeModel());
        setState(() {
          currentPage++;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else if (mounted && updateList == true) {
        // widget.sc.
        setState(() {
          currentPage++;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
      print('THIS ERROR HAS BEEN ENCOUNTERED ${e.toString()}');
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(opacity: _isLoadingMore ? 1.0 : 0.0, child: new Loading()),
      ),
    );
  }

  showSubcategorySelection() {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
      ),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text('choose subcategory'.tr(), style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .4, fontSize: 18)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemCount: ddCategoriesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemList(ddCategoriesList[index], index);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _itemList(Category categories, index) {
    return Column(
      children: [
        ListTile(
          title: Text(
            categories.name.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .4),
            textAlign: TextAlign.center,
          ),
          onTap: () async {
            Navigator.pop(context, categories);
          },
        ),
        Divider(height: 3, color: Colors.grey[400]),
      ],
    );
  }

  handleLoveClick(int index) async {
    bool _guestUser = context.read<SignInBloc>().guestUser;
    ApiArticle apiArticle = adsList[index] as ApiArticle;
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
    ApiArticle apiArticle = adsList[index] as ApiArticle;

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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
