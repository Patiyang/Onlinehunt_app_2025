// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:online_hunt_news/models/apiArticleModel.dart';
// import 'package:online_hunt_news/utils/cached_image.dart';
// import 'package:online_hunt_news/utils/next_screen.dart';
// import 'package:online_hunt_news/widgets/video_icon.dart';

// import '../models/apiUserModel.dart';
// import '../pages/followScreen/author_details.dart';
// import '../services/userServices.dart';
// import '../utils/loading_cards.dart';

// class SliverCard1 extends StatelessWidget {
//   // final ApiArticle apiArticle!.
//   final String heroTag;
//   final ApiArticle? apiArticle;
//   final String? categoryName;
//   const SliverCard1({Key? key, required this.heroTag, this.apiArticle, this.categoryName}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         padding: EdgeInsets.all(15),
//         margin: EdgeInsets.only(bottom: 15),
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColorLight,
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Hero(
//                   tag: heroTag,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                         child: CustomCacheImage(imageUrl: apiArticle!.imageUrl, radius: 5.0),
//                       ),
//                       VideoIcon(contentType: apiArticle!.videoUrl!.isEmpty ? 'Image' : 'video', iconSize: 40),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Text(
//               apiArticle!.title!,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
//               child: Text(
//                 categoryName!,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Flexible(
//                   flex: 5,
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             FutureBuilder(
//               future: UserServices().userDetails(apiArticle!.userId!),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 ApiUserModel user = snapshot.data;
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingCard(height: 40, width: 100);
//                 }
//                 if (snapshot.hasData) {
//                   return InkWell(
//                     onTap: () => nextScreen(context, AuthorDetails(apiUserModel: user)),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => print("https://onlinehunt.in/news/${user.avatar!}"),
//                           child: user.avatar!.isEmpty
//                               ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
//                               : CircleAvatar(
//                                   radius: 15,
//                                   backgroundColor: Colors.grey[300],
//                                   backgroundImage: CachedNetworkImageProvider("https://onlinehunt.in/news/${user.avatar!}"),
//                                 ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(' ${user.userName!}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   );
//                 }
//                 if (snapshot.hasError) {
//                   log(snapshot.error.toString());
//                 }
//                 return SizedBox.shrink();
//               },
//             ),
//             SizedBox(height: 15),
//             Row(
//               children: <Widget>[
//                 Icon(CupertinoIcons.time, color: Colors.grey, size: 20),
//                 SizedBox(width: 5),
//                 Text(apiArticle!.createdAt!, style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
//                 Spacer(),
//                 Icon(Icons.favorite, color: Theme.of(context).secondaryHeaderColor, size: 20),
//                 SizedBox(width: 3),
//                 // Text(apiArticle!.loves.toString(),
//                 //     style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
//               ],
//             ),
//           ],
//         ),
//       ),
//       onTap: () => navigateToDetailsScreen(context, apiArticle!, heroTag, categoryName!),
//     );
//   }
// }
