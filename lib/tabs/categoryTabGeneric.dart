import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/blocs/tab_index_bloc.dart';
import 'package:online_hunt_news/cards/card2.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/like_model.dart';
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
  List<DocumentSnapshot> _snap = [];
  // List<Article> _data = [];
  List<PostModel> posts = [];
  List<Category> ddCategoriesList = [];
  Category? selectedSubCat;
  // List<ApiArticle> articles = [];
  int _lastIndex = 0;
  int currentPage = 1;

  bool? _hasData;
  QuerySnapshot? rawData;
  DocumentSnapshot? _lastVisible;
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
      getApiData(mounted, true);
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
                          EmptyPage(icon: Feather.clipboard, message: 'no articles found'.tr(), message1: ''),
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
                            heroTag: 'tab1$index',postModel: posts[index],
                            // apiArticle: adsList[index] as ApiArticle,
                            // handlnigLike: handlingLikes[index],
                            // likeId: likeId[index],
                            liked: false,
                            handleLoveCLick: () => handleLoveClick(index),
                          );
                          // if (adsList[index] is ApiArticle) {
                          //   // bool handlingLike = true;
                          //   // bool liked = false;
                          //   // LikeModel? likeId;
                          //   return Card2(
                          //     categoryName: selectedSubCat == null ? '--' : selectedSubCat!.name,
                          //     heroTag: 'tab1$index',
                          //     // apiArticle: adsList[index] as ApiArticle,
                          //     handlnigLike: handlingLikes[index],
                          //     likeId: likeId[index],
                          //     liked: liked[index],
                          //     handleLoveCLick: () => handleLoveClick(index),
                          //   );
                          // } else {
                          //   return GestureDetector(
                          //     onTap: () {
                          //       print(adsList.where((element) => element.runtimeType == MobileAdsaModel ? true : false));
                          //     },
                          //     child: CustomMobileAd.getBannerAd(context, mobileAds[index ~/ 5]),
                          //   );
                          // }
                        },
                      ),
                // Align(
                //   alignment: Alignment.bottomLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: ddCategoriesList.length == 1
                //         ? SizedBox.shrink()
                //         : Container(
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.grey.shade300,
                //               gradient: LinearGradient(
                //                 colors: [Config().appColor, Colors.grey.shade600],
                //                 begin: Alignment.bottomCenter,
                //                 end: Alignment.topCenter,
                //               ),
                //             ),
                //             child: IconButton(
                //               onPressed: () async {
                //                 var value = await showSubcategorySelection();
                //                 if (value == null) {
                //                   print('no subcategory selected');
                //                 } else {
                //                   setState(() {
                //                     selectedSubCat = value;
                //                   });
                //                   getApiData(mounted, selectedSubCat!, false);
                //                 }
                //               },
                //               icon: Icon(Icons.sort),
                //               color: Colors.white,
                //             ),
                //           ),
                //   ),
                // ),
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
    List<PostModel> articles = [];

    try {
      await categoryServices
          .getCategoriesWithPosts(widget.apiCategory!.id)
          .then((value) {
            response = jsonDecode(value.body);
            print(response['posts'].length);
          })
          .whenComplete(() {
            for (int i = 0; i < response['posts'].length; i++) {
              posts.add(PostModel.fromJson(response['posts'][i]));
            }
            _lastIndex = _lastIndex + 4;
          });
      // articles.forEach((element) {
      //   if (element.langId == languageID && element.categoryId == category.categoyId!) {
      //     if (_articlesData.isNotEmpty) {
      //       _articlesData.any((data) {
      //         if (data.id == element.id) {
      //           print('true');
      //           return false;
      //         } else {
      //           _articlesData.add(element);

      //           print('false');
      //           return true;
      //         }
      //       });
      //     } else {
      //       _articlesData.add(element);
      //     }

      //     // stringList.add(element.id!);
      //   }
      // });
      // _articlesData.removeWhere((element) => element.visibility == '0' ? true : false);

      // adsList = List.from(posts);

      // await AdServices().getMobileAds(currentPage.toString(), adspace: 'post_detail_ad', categoryId: category.categoyId.toString()).then((value) {
      //   if (value.isNotEmpty) {
      //     MobileAdsaModel _mobileAdsaModel;
      //     _mobileAdsaModel = value[0];
      //     mobileAds.add(_mobileAdsaModel);
      //     // Fluttertoast.showToast(msg: value.toString());

      //     for (int i = 0; i <= adsList.length; i++) {
      //       if ((i + 1) % 5 == 0) {
      //         adsList.insert(i, mobileAds[currentPage - 1]);
      //       }
      //     }
      //   } else {
      //     mobileAds.forEach((element) {
      //       adsList.insert((4 * (mobileAds.indexOf(element) + 1)), element);
      //     });
      //   }
      // });
      // adsList.forEach((element) {
      //   liked.add(false);
      //   likeId.add(LikeModel());
      //   handlingLikes.add(false);
      //   getLikeStatus(adsList.indexOf(element));
      // });
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

  getAriclesLength() {
    // if (_articlesData.length > 20 && _articlesData.length < 75) {
    //   return 3;
    // } else if (_articlesData.length > 75 && _articlesData.length < 100) {
    //   return 6;
    // } else if (_articlesData.length > 100) {
    //   return 8;
    // }
  }

  Future categoriesStream() async {
    Map<String, dynamic> response = {};
    List<ApiCategories> dummyList = [];
    int language = await returnCategoryId();
    List<ApiCategories> apiCategories = [];
    ddCategoriesList = [];

    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response['data'].forEach((element) {
              dummyList.add(ApiCategories.fromJson(element));
            });
          });
      // dummyList.forEach((element) {
      //   if (element.parentId == widget.apiCategory!.categoyId) {
      //     ddCategoriesList.add(element);
      //   }
      //   if (element.languageId == language && element.parentId == '0') {
      //     apiCategories.add(element);
      //   }
      // });
      // ddCategoriesList.insert(0, dummyList.where((element) => element.categoyId == widget.apiCategory!.categoyId ? true : false).first);

      selectedSubCat = ddCategoriesList[0];
    } catch (e) {
      print(e.toString());
    }

    return apiCategories;
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
