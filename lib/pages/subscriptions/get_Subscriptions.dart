// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:online_hunt_news/pages/followScreen/author_details.dart';
// import 'package:online_hunt_news/services/userServices.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../blocs/notification_bloc.dart';
// import '../../blocs/sign_in_bloc.dart';
// import '../../cards/card1.dart';
// import '../../helpers&Widgets/key.dart';
// import '../../helpers&Widgets/loading.dart';
// import '../../models/apiArticleModel.dart';
// import '../../models/apiCategoriesModel.dart';
// import '../../models/apiUserModel.dart';
// import '../../models/followingModel.dart';
// import '../../models/like_model.dart';
// import '../../services/category_services.dart';
// import '../../services/post_service.dart';
// import '../../utils/loading_cards.dart';
// import '../../utils/next_screen.dart';
// import '../../utils/sign_in_dialog.dart';

// class MySubscriptions extends StatefulWidget {
//   const MySubscriptions({Key? key}) : super(key: key);

//   @override
//   State<MySubscriptions> createState() => _MySubscriptionsState();
// }

// class _MySubscriptionsState extends State<MySubscriptions> {
//   UserServices _userServices = new UserServices();
//   List<ApiUserModel> users = [];
//   List<FollowingModel> followingStats = [];
//   List<LikeModel> likedItem = [];
//   List<ApiArticle> likedContent = [];
//   bool gettingFollowing = true;
//   bool gettingLiked = true;
//   PostServices postServices = new PostServices();
//   CategoryServices categoryServices = CategoryServices();
//   List<ApiCategories> apiCategories = [];

//   UserServices userServices = UserServices();
//   String uid = '';
//   List<bool> handlingLikes = [];
//   List<bool> liked = [];
//   List<LikeModel> likeId = [];
//   @override
//   void initState() {
//     // getData();
//     getlikedItem();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: GestureDetector(onTap: () => print(likedContent), child: Text('liked posts'.tr())),
//       ),
//       body: gettingLiked == true
//           ? Center(
//               child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
//             )
//           : likedContent.isEmpty
//           ? Center(child: Text('not yet subscribed'.tr()))
//           : RefreshIndicator(
//               onRefresh: () => getlikedItem(),
//               child: ListView.separated(
//                 padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
//                 shrinkWrap: true,
//                 // physics: NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemCount: likedContent.isEmpty ? 2 : likedContent.length,
//                 separatorBuilder: (context, index) => SizedBox(height: 15),
//                 itemBuilder: (BuildContext context, int index) {
//                   return FutureBuilder(
//                     future: categoriesStream(likedContent[index].categoryId!),
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                       if (snapshot.data.toString().isEmpty) {
//                         return GestureDetector(onTap: () => print(likedContent.length), child: SizedBox.shrink());
//                       }
//                       if (snapshot.hasData && snapshot.data.toString().isNotEmpty) {
//                         return Card1(
//                           heroTag: 'popular$index',
//                           // apiArticle: likedContent[index],
//                           categoryTitle: apiCategories.where((element) => element.categoyId == snapshot.data ? true : false).first.categoryName!,
//                           categoryName: snapshot.data,
//                           handlnigLike: handlingLikes[index],
//                           likeId: likeId[index],
//                           liked: liked[index],
//                           handleLoveCLick: () => handleLoveClick(index),
//                         );
//                       }
//                       return LoadingCard(height: 200);
//                     },
//                   );
//                 },
//               ),

//               // GridView.builder(
//               //   padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
//               //   gridDelegate:
//               //       const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1),
//               //   itemCount: users.length,
//               //   itemBuilder: (BuildContext context, int index) {
//               //     ApiUserModel singleuser = users[index];
//               //     return UserList(d: singleuser);
//               //   },
//               // ),
//             ),
//     );
//   }

//   getData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await _userServices.getFollowing(prefs.getString('uid'), 'get_following').then((value) {
//       followingStats = value;
//     });
//     followingStats.forEach((element) async {
//       users.add(await _userServices.userDetails(element.followingId!));
//     });

//     Future.delayed(Duration(seconds: 2)).then((value) {
//       setState(() {
//         gettingFollowing = false;
//       });
//     });
//   }

//   getlikedItem() async {
//     setState(() {
//       gettingLiked = true;
//     });
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     uid = sp.getString('uid')!;

//     await _userServices
//         .getAllFavorite(uid)
//         .then((value) {
//           print('length of liked favorite is ${value.length}');
//           likedItem = value;
//           if (value.isNotEmpty) {
//             likedItem.forEach((element) async {
//               getApiArticleById(element.postId!);
//             });
//           } else {
//             setState(() {
//               gettingLiked = false;
//             });
//           }
//         })
//         .catchError((onError) {
//           print('error encountered is$onError');
//         })
//         .whenComplete(() {
//           print('length of liked articles is ${likedContent.length}');
//         });
//   }

//   Future getApiArticleById(String id) async {
//     Map<String, dynamic> response = {};
//     List<ApiArticle> articles = [];
//     likedContent.clear();
//     await postServices
//         .getAllPosts('single_post')
//         .then((value) {
//           response = jsonDecode(utf8.decode(value.bodyBytes));
//         })
//         .catchError((onError) {
//           print(onError);
//         })
//         .whenComplete(() {
//           response['data'].forEach((element) {
//             articles.add(ApiArticle.fromJson(element));
//           });
//           // for (int i = 0; i < response.length; i++) {}
//         });
//     likedContent.add(articles[0]);
//     if (likedItem.length == likedContent.length && likedItem.isNotEmpty) {
//       likedContent.forEach((element) {
//         liked.add(false);
//         likeId.add(LikeModel());
//         handlingLikes.add(false);
//         getLikeStatus(likedContent.indexOf(element));
//       });
//       if (mounted) {
//         setState(() {
//           gettingLiked = false;
//         });
//       }
//     }
//     // print('length of liked articles is ${likedContent.length}');
//     // return articles[0];
//   }

//   handleLoveClick(int index) async {
//     bool _guestUser = context.read<SignInBloc>().guestUser;
//     ApiArticle apiArticle = likedContent[index];
//     if (_guestUser == true) {
//       openSignInDialog(context);
//     } else {
//       if (liked[index] == true) {
//         // Fluttertoast.showToast(msg: 'msg');
//         setState(() {
//           handlingLikes[index] = true;
//         });
//         var params = {"api_key": "$apiKey", "id": "${likeId[index].id}"};
//         print(params);
//         await userServices.deleteFav(params).whenComplete(() => getLikeStatus(index));
//       } else {
//         var params = {"api_key": "$apiKey", "user_id": "$uid", "post_id": "${apiArticle.id}", "category_id": "${apiArticle.categoryId}"};
//         setState(() {
//           handlingLikes[index] = true;
//         });
//         userServices.createFav(params).whenComplete(() => getLikeStatus(index));
//       }
//     }
//   }

//   getLikeStatus(int index) async {
//     ApiArticle apiArticle = likedContent[index];

//     await userServices.getFavorite(apiArticle.id, uid).then((value) {
//       if (value.isNotEmpty) {
//         // Fluttertoast.showToast(msg: 'msg');
//         liked[index] = true;
//         likeId[index] = value[0];
//         handlingLikes[index] = false;
//         if (mounted) {
//           setState(() {});
//         }
//       } else {
//         liked[index] = false;
//         handlingLikes[index] = false;
//         if (mounted) {
//           setState(() {});
//         }
//       }
//     });
//   }

//   categoriesStream(String categoryId) async {
//     List response = [];
//     List<ApiCategories> dummyList = [];
//     String language = await returnCategoryId();
//     apiCategories = [];
//     String categoryName = '';
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
//     for (int i = 0; i < apiCategories.length; i++) {
//       if (apiCategories[i].categoyId == categoryId) {
//         // setState(() {
//         categoryName = apiCategories[i].categoyId!;
//         // });
//       }
//     }
//     return categoryName;
//   }
// }

// class UserList extends StatelessWidget {
//   final ApiUserModel d;
//   const UserList({Key? key, required this.d}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).shadowColor,
//           // gradient: LinearGradient(
//           //     colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(.2)],
//           //     begin: Alignment.bottomCenter,
//           //     end: Alignment.topCenter),
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 3), color: Theme.of(context).shadowColor)],
//         ),
//         child: Stack(
//           // mainAxisSize: MainAxisSize.min,
//           children: [
//             Hero(
//               tag: d.id!,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 child: CachedNetworkImage(
//                   imageUrl: d.avatar!.contains('https') ? d.avatar! : "https://onlinehunt.in/news/${d.avatar}",
//                   fit: BoxFit.contain,
//                   placeholder: (_, url) => CustomPlaceHolder(size: 56),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Theme.of(context).shadowColor, Theme.of(context).shadowColor.withOpacity(.8)],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   /*  */
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
//                 ),
//                 padding: EdgeInsets.only(left: 5, right: 10, bottom: 5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(d.userName!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.6)),
//                     Text(d.email!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: -0.6)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       onTap: () {
//         nextScreen(context, AuthorDetails(apiUserModel: d));
//       },
//     );
//   }
// }
