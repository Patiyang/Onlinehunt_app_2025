
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/cards/featured_card.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({Key? key}) : super(key: key);

  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int listIndex = 0;
  CategoryServices categoryServices = CategoryServices();
  List<ApiCategories> apiCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 250,
          width: w,
          child: PageView.builder(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            itemCount: fb.posts.isEmpty ? 1 : fb.posts.length,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  listIndex = index;
                });
              }
            },
            itemBuilder: (BuildContext context, int index) {
              if (fb.posts.isEmpty) return LoadingFeaturedCard();
            return  FeaturedCard(
                apiArticle: fb.posts[index],
                heroTag: 'featured$index',
                categoryName: fb.posts[index].category!.name,
              );
              return null;
              // return FutureBuilder(
              //   future: categoriesStream(fb.apiArticle[index].categoryId),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     return snapshot.connectionState == ConnectionState.waiting
              //         ? LoadingFeaturedCard()
              //         : snapshot.hasData && snapshot.data != null
              //         ?
              //         : LoadingFeaturedCard();
              //   },
              // );
            },
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: DotsIndicator(
            dotsCount: fb.posts.isEmpty ? 5 : fb.posts.length,
            position: listIndex.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(20.0, 4.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }

  // categoriesStream(String? categoryId) async {
  //   List response = [];
  //   List<ApiCategories> dummyList = [];
  //   int language = await returnCategoryId();
  //   apiCategories = [];
  //   String categoryName = '';
  //   try {
  //     await categoryServices
  //         .getCategories()
  //         .then((value) {
  //           response = jsonDecode(utf8.decode(value.bodyBytes));
  //         })
  //         .whenComplete(() {
  //           response.forEach((element) {
  //             dummyList.add(ApiCategories.fromJson(element));
  //           });
  //         });
  //     dummyList.forEach((element) {
  //       if (element.languageId == language) {
  //         apiCategories.add(element);
  //       }
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   for (int i = 0; i < apiCategories.length; i++) {
  //     if (apiCategories[i].categoyId == categoryId) {
  //       // setState(() {
  //       categoryName = apiCategories[i].categoyId!;
  //       // });
  //     }
  //   }
  //   return categoryName;
  // }
}
