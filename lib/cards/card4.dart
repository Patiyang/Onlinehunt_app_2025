import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/bookmarkPostModel.dart';
import 'package:online_hunt_news/pages/article_details.dart';
import 'package:online_hunt_news/pages/video_article_details.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/video_icon.dart';

class Card4 extends StatelessWidget {
  final String heroTag;
  final BookmarkPostModel? apiArticle;
  // final String? categoryName;
  const Card4({Key? key, required this.heroTag, this.apiArticle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  child: Hero(
                    tag: heroTag,
                    child: CustomCacheImage(imageUrl: apiArticle!.imageUrl, radius: 5.0,videoUrl: apiArticle!.video_url,contentType:apiArticle!.video_url!.isNotEmpty?'video':'article' ,),
                  ),
                ),
                VideoIcon(contentType: apiArticle!.video_url!.isNotEmpty?'video':'article', iconSize: 40),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apiArticle!.title ?? '',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.time_solid, color: Colors.grey[400], size: 20),
                        SizedBox(width: 5),
                        Text(apiArticle!.saved_at , style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
                        Spacer(),
                        // Icon(Icons.favorite, color: Colors.grey, size: 20),
                        SizedBox(width: 3),
                        // Text(d.loves.toString(), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () =>apiArticle!.video_url!.isNotEmpty?nextScreen(context, VideoArticleDetails(slug: apiArticle!.slug)):nextScreen(context, ArticleDetails(post_id: null, slug: apiArticle!.slug)),
      // onTap: () => print('card 4 tapped'),
    );
  }
}
