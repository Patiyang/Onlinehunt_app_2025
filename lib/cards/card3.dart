
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/authorModel.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';


class Card3 extends StatelessWidget {
  final PostModel? postModel;
  final Author? author;
  // final ApiArticle? apiArticle;
  final String? heroTag;
  final bool? replace;
  final String? categoryName;
  const Card3({Key? key, required this.heroTag, this.replace, this.categoryName, required this.postModel, this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heroTag == null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                            child: CustomCacheImage(imageUrl: postModel!.imageUrl, radius: 5.0),
                          ),
                          // VideoIcon(contentType: postModel!.videoUrl!.isEmpty ? 'Image' : 'video', iconSize: 60),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 160,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                            child: Hero(
                              tag: heroTag!,
                              child: CustomCacheImage(imageUrl: postModel!.imageUrl, radius: 5.0),
                            ),
                          ),
                          // VideoIcon(contentType: apiArticle!.videoUrl!.isEmpty ? 'Image' : 'video', iconSize: 60),
                        ],
                      ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postModel!.title,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        // onTap: () => nextScreen(context, AuthorDetails(apiUserModel: author!)),
                        onTap: () => print('Author tapped'),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("${HelperClass.avatarIp}/${author!.avatar!}"),
                              child: author!.avatar!.isEmpty
                                  ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}/${author!.avatar!}",),
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(' ${author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      // FutureBuilder(
                      //   future: UserServices().userDetails(apiArticle!.userId!),
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //     ApiUserModel user = snapshot.data;
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return LoadingCard(height: 40, width: 100);
                      //     }
                      //     if (snapshot.hasData) {
                      //       return
                      //     }
                      //     if (snapshot.hasError) {
                      //       log(snapshot.error.toString());
                      //     }
                      //     return SizedBox.shrink();
                      //   },
                      // ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      // Text(
                      //   apiArticle!.title!,
                      //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      //   maxLines: 4,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
                        child: Text(
                          categoryName!,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // FutureBuilder(
            //   future: UserServices().userDetails(apiArticle!.userId!),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     ApiUserModel user = snapshot.data;
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return LoadingCard(
            //         height: 40,
            //         width: 100,
            //       );
            //     }
            //     if (snapshot.hasData) {
            //       return InkWell(
            //         onTap: () => nextScreen(
            //             context,
            //             AuthorDetails(
            //               apiUserModel: user,
            //             )),
            //         child: Row(
            //           children: [
            //             GestureDetector(
            //                 onTap: () => print("https://onlinehunt.in/news/${user.avatar!}"),
            //                 child: user.avatar!.isEmpty
            //                     ? CircleAvatar(
            //                         radius: 15,
            //                         backgroundColor: Colors.grey[300],
            //                         child: Icon(
            //                           Icons.person,
            //                         ),
            //                       )
            //                     : CircleAvatar(
            //                         radius: 15,
            //                         backgroundColor: Colors.grey[300],
            //                         backgroundImage: CachedNetworkImageProvider("https://onlinehunt.in/news/${user.avatar!}"))),
            //             SizedBox(width: 10),
            //             Text(
            //               ' ${user.userName!}',
            //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            //             ),
            //           ],
            //         ),
            //       );
            //     }
            //     if (snapshot.hasError) {
            //       log(snapshot.error.toString());
            //     }
            //     return SizedBox.shrink();
            //   },
            // ),
            // // SizedBox(
            // //   width: 5,
            // // ),
            // // Text(
            // //   apiArticle!.title!,
            // //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            // //   maxLines: 4,
            // //   overflow: TextOverflow.ellipsis,
            // // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
            //   child: Text(
            //     categoryName!,
            //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   children: <Widget>[
            //     Icon(
            //       CupertinoIcons.time,
            //       color: Theme.of(context).secondaryHeaderColor,
            //       size: 20,
            //     ),
            //     SizedBox(
            //       width: 2,
            //     ),
            //     Text(
            //       apiArticle!.createdAt!,
            //       style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13),
            //     ),
            //     Spacer(),
            //     Icon(
            //       Icons.favorite,
            //       color: Colors.grey,
            //       size: 20,
            //     ),
            //     SizedBox(
            //       width: 3,
            //     ),
            //     // Text(apiArticle!.loves.toString(), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
            //   ],
            // )
          ],
        ),
      ),
      onTap: () => navigateToDetailsScreen(context, postModel!, heroTag, categoryName!),
      // onTap: () => print('Tapped on card 3'),
    );
  }
}
