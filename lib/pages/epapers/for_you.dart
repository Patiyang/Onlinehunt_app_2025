import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coverflow_carousel/coverflow_carousel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/blocs/featured_epapers.dart';
import 'package:online_hunt_news/blocs/magazine_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/cover_flow.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaperModel.dart';
import 'package:online_hunt_news/models/epaper_categories.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/pages/epapers/more_epapers.dart';
import 'package:online_hunt_news/pages/more_articles.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> with AutomaticKeepAliveClientMixin {
  List<EpaperModel> featuredPapers = [];
  List<MagazineCategory> magazineCategories = [];
  MagazineCategory? selectedCategory;
  int currentfeaturedPage = 0;
  PageController? controller;

  @override
  void initState() {
    initializePapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<FeaturedEpapersBloc>();
    final mb = context.watch<MagazineCategoriesBloc>();
    final fm = context.watch<FavoriteMagazineBloc>();

    return ep.loading
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                ep.onRefresh(mounted);
                mb.onRefresh(mounted);
                // fm.onRefresh(mounted, selectedCategory!.id);
                fm.setLoading(true);
              },
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
                          ),
                          child: TextButton.icon(
                            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                            onPressed: () {},
                            label: Text('search', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)).tr(),
                            icon: Icon(Icons.search, color: Theme.of(context).textTheme.bodyMedium!.color),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
                          ),

                          // width: 300,
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                isExpanded: false,
                                hint: Text('genre'.tr()),
                                value: selectedCategory != null ? selectedCategory : null,
                                onChanged: (MagazineCategory? val) async {
                                  print(selectedCategory!.name == val!.name);
                                  selectedCategory = val;
                                  fm.setLoading(true);
                                  await fm.onRefresh(mounted, selectedCategory!.id);
                                  fm.setLoading(false);
                                  // getDistricts();
                                },
                                items: magazineCategories.map((cat) => DropdownMenuItem(child: Text(cat.name), value: cat)).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CoverflowCarousel.builder(
                    height: 330,
                    itemCount: ep.data.length,
                    itemHeight: 300,
                    itemWidth: 210,
                    scrollDirection: Axis.horizontal,
                    animationCurve: Curves.easeIn,
                    animationDuration: Duration(seconds: 1),
                    itemBuilder: (context, index) {
                      var singlePaper = ep.data[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: '${HelperClass.mediaIp}${singlePaper.cover_image!}',
                          placeholder: (context, url) => Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) {
                            return Image.asset(Config().splashIcon, height: 300, width: 120, fit: BoxFit.cover);
                          },
                        ),
                      );
                    },
                  ),

                  Divider(endIndent: 15, indent: 15, color: Theme.of(context).shadowColor.withAlpha(50)),

                  Visibility(
                    visible: !mb.loading,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 15),
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
                              // pb.getApiData(mounted, context);
                            },
                            child: Text(
                              '${selectedCategory!.name ?? '...'} ${'news'.tr()}',
                              style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            child: Text('view all', style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 16)).tr(),
                            onPressed: () => nextScreen(context, MoreEpapers(categoryId: selectedCategory!.id)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: fm.data.isEmpty ? 3 : fm.data.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // EpaperModel singlePaper = fm.data[index];
                        return fm.data.isEmpty
                            ? LoadingCard(height: 300, width: 210)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: 300,
                                  width: 210,
                                  fit: BoxFit.cover,
                                  imageUrl: '${HelperClass.mediaIp}${fm.data[index].cover_image!}',
                                  placeholder: (context, url) => Container(color: Colors.grey[300]),
                                  errorWidget: (context, url, error) {
                                    return Image.asset(Config().splashIcon, height: 300, width: 120, fit: BoxFit.cover);
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void initializePapers() async {
    final cb = context.read<FeaturedEpapersBloc>();
    final mb = context.read<MagazineCategoriesBloc>();
    final fm = context.read<FavoriteMagazineBloc>();

    cb.getData(mounted).whenComplete(() {
      for (var element in cb.data) {
        featuredPapers.add(element);
      }
    });
    await mb.getData(mounted).whenComplete(() {
      for (var element in mb.data) {
        magazineCategories.add(element);
      }
      selectedCategory = magazineCategories[0];
    });
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      print('${t.tick}${selectedCategory!.name}');
      if (selectedCategory != null) {
        fm.getData(mounted, selectedCategory!.id).whenComplete(() {
          t.cancel();
          print('timer canceles');
        });
        fm.setLoading(false);
        // setState(() {});
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
