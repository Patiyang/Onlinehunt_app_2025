
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/video_icon.dart';

import '../pages/followScreen/author_details.dart';

class SliverCard extends StatelessWidget {
  // final ApiArticle d;
  final String heroTag;
  final PostModel? apiArticle;
  final String? categoryName;
  const SliverCard({Key? key, required this.heroTag, this.apiArticle, this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Wrap(
          children: [
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImage(imageUrl: apiArticle!.imageUrl, radius: 5.0, circularShape: false),
                  ),
                  VideoIcon(contentType: 'Image', iconSize: 80),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apiArticle!.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.time, size: 16, color: Colors.grey),
                      SizedBox(width: 3),
                      Text(apiArticle!.createdAt, style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor)),
                      Spacer(),
                      Icon(Icons.favorite, size: 16, color: Colors.grey),
                      SizedBox(width: 3),
                      // Text(
                      //   d.loves.toString(),
                      //   style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
                      // )
                    ],
                  ),
                  SizedBox(height: 10),
                   InkWell(
                          onTap: () => nextScreen(context, AuthorDetails(apiUserModel: apiArticle!.author!)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => print("${HelperClass.avatarIp}${apiArticle!.author!.avatar!}"),
                                child: apiArticle!.author!.avatar!.isEmpty
                                    ? CircleAvatar(radius: 15, backgroundColor: Colors.grey[300], child: Icon(Icons.person))
                                    : CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: CachedNetworkImageProvider("${HelperClass.avatarIp}${apiArticle!.author!.avatar!}"),
                                      ),
                              ),
                              SizedBox(width: 10),
                              Text(' ${apiArticle!.author!.username}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                  //       log(snapshot.error.toString());
                  //     }
                  //     return SizedBox.shrink();
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      // onTap: () => navigateToDetailsScreen(context, apiArticle!, heroTag, categoryName!),
      onTap: ()=>print('sliver card tapped'),
    );
  }
}
