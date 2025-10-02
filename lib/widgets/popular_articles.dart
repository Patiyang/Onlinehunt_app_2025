import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/popular_articles_bloc.dart';
import 'package:online_hunt_news/cards/card1.dart';
import 'package:online_hunt_news/pages/more_articles.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PopularWidget extends StatefulWidget {
  PopularWidget({Key? key}) : super(key: key);

  @override
  State<PopularWidget> createState() => _PopularWidgetState();
}

class _PopularWidgetState extends State<PopularWidget> {
  CategoryServices categoryServices = CategoryServices();
  // List<ApiCategories> apiCategories = [];
  @override
  Widget build(BuildContext context) {
    final pb = context.watch<PopularBloc>();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 23,
                width: 4,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  pb.getApiData(mounted, context);
                },
                child: Text('featured news', style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold)).tr(),
              ),
              Spacer(),
              TextButton(
                child: Text('view all', style: TextStyle(color: Theme.of(context).primaryColorDark)).tr(),
                onPressed: () => nextScreen(context, MoreArticles(title: 'featured news')),
              ),
            ],
          ),
        ),
        pb.loading == true
            ? Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15), child: LoadingCard(height: 200))
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: pb.apiArticle.isEmpty ? 2 : pb.apiArticle.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (BuildContext context, int index) {
                    if (pb.posts.isEmpty) return LoadingCard(height: 200);
                    return Card1(
                      authorModel: pb.posts[index].author!,
                      heroTag: 'popular$index',
                      // apiArticle: pb.apiArticle[index],
                      postModel: pb.posts[index],
                    );
                    // return Text(
                    //   pb.posts[index].author!.avatar ?? '',
                    //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    //   maxLines: 7,
                    //   overflow: TextOverflow.ellipsis,
                    // );
                    // if (pb.adsList[index] is ApiArticle) {
                    //   if (pb.apiArticle.isEmpty) return LoadingCard(height: 200);

                    //   return FutureBuilder(
                    //     future: categoriesStream(pb.adsList[index].categoryId!),
                    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //       return snapshot.hasData
                    //           ? Card1(
                    //               heroTag: 'popular$index',
                    //               apiArticle: pb.adsList[index],
                    //               categoryTitle: apiCategories.where((element) => element.categoyId == snapshot.data ? true : false).first.categoryName!,
                    //               categoryName: snapshot.data,
                    //             )
                    //           : LoadingCard(height: 200);
                    //     },
                    //   );
                    // } else if (pb.adsList[index] is MobileAdsaModel) {
                    //   return GestureDetector(
                    //     onTap: () {
                    //       // print(adsList.where((element) => element.runtimeType == MobileAdsaModel ? true : false));
                    //     },
                    //     child: CustomMobileAd.getBannerAd(context, pb.adsList[index]),
                    //   );
                    //   ;
                    // } else {
                    //   return SizedBox.shrink();
                    // }
                  },
                ),
              ),
      ],
    );
  }
}
