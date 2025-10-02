import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/widgets/video_icon.dart';

class Card5 extends StatelessWidget {
  // final Article d;
  final String heroTag;
  final ApiArticle? apiArticle;
  final String? categoryName;
  const Card5({Key? key, required this.heroTag, this.apiArticle, this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Wrap(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: heroTag,
                    child: CustomCacheImage(imageUrl: apiArticle!.imageUrl, radius: 5.0, circularShape: false),
                  ),
                ),
                VideoIcon(contentType: apiArticle!.videoUrl!.isEmpty ? 'Image' : 'video', iconSize: 80),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apiArticle!.title ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.time, size: 16, color: Theme.of(context).secondaryHeaderColor),
                      SizedBox(width: 3),
                      Text(apiArticle!.createdAt ?? '', style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor)),
                      Spacer(),
                      Icon(Icons.favorite, size: 16, color: Colors.grey),
                      SizedBox(width: 3),
                      // Text(
                      //   d.loves.toString(),
                      //   style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // onTap: () => navigateToDetailsScreen(context, apiArticle!, heroTag, apiArticle!.categoryId!),
            onTap: () => print('card 5 tapped'),

    );
  }
}
