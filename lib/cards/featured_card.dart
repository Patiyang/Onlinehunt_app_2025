import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/utils/cached_image.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/video_icon.dart';

class FeaturedCard extends StatefulWidget {
  // final Article d;
  final heroTag;
  final PostModel? apiArticle;
  final String? categoryName;
  // final String categoryId;
  const FeaturedCard({Key? key, required this.heroTag, this.apiArticle, this.categoryName}) : super(key: key);

  @override
  State<FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  CategoryServices categoryServices = CategoryServices();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
                  ),
                  child: Hero(
                    tag: widget.heroTag,
                    child: CustomCacheImage(imageUrl: widget.apiArticle!.imageUrl, radius: 5, avatarUrl: '${HelperClass.avatarIp}${widget.apiArticle!.author!.avatar}', contentType: 'article'),
                  ),
                ),
                VideoIcon(contentType: 'Image'),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor),
                      child: Text(
                        widget.categoryName!,
                        style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.titleSmall!.fontSize! - 2, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    //   height: 30,
                    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black45),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(Icons.favorite, size: 20, color: Colors.white),
                    //       SizedBox(width: 2),
                    //       // Text(
                    //       //   d.loves.toString(),
                    //       //   style: TextStyle(color: Colors.white),
                    //       // )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.apiArticle!.title ?? '--',
                      style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.time, size: 16, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          widget.apiArticle!.createdAt ?? '',
                          style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.titleSmall!.fontSize! - 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () async => navigateToDetailsScreen(context, widget.apiArticle!, widget.heroTag, widget.apiArticle!.category!.id.toString()),
      // onTap:()=>print('featured card tapped')
    );
  }
}
