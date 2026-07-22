import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/magazine_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_categories.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';

class Magazines extends StatefulWidget {
  final MagazineCategory? magazineCategory;
  final ScrollController? sc;  final int refreshToken;
  const Magazines({super.key, required this.magazineCategory, this.sc, required this.refreshToken});

  @override
  State<Magazines> createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> with AutomaticKeepAliveClientMixin {
  List<EpaperModel> magazines = [];
  bool isLoading = true;
  ScrollController? controller;
  EpaperServices epaperServices = EpaperServices();
  @override
  void initState() {
    getData();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      // context.read<MagazineBloc>().onRefresh(mounted);
    });
    super.initState();
  }
  @override
  void didUpdateWidget(covariant Magazines oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      getData();
    }
  }
  void _scrollListener() {}
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final ep = context.watch<MagazineBloc>();
    return Column(
      children: [
        Padding(
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
                  // fp.getApiData(mounted, context);
                },
                child: Text(widget.magazineCategory!.name, style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold)),
              ),
              Spacer(),
     
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: magazines.isEmpty ? 2 : magazines.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              // EpaperModel paper =fp.data.isEmpty?EpaperModel(): fp.data[index];

              return magazines.isEmpty
                  ? LoadingCard(height: 300, width: 210)
                  : magazines[index].source_type == 'website'
                  ? URLepaper(epaperModel: magazines[index], customUrl: true)
                  : PDFepaper(epaperModel: magazines[index]);
            },
          ),
        ),
      ],
    );
  }

  getData() async {
    magazines.clear();
    await EpaperServices().getMagazines(category_id: widget.magazineCategory!.id).then((value) {
      Map<String, dynamic> response = {};

      response = jsonDecode(value.body);
      // print(response['data']);
      for (int i = 0; i < response['data'].length; i++) {
        magazines.add(EpaperModel.fromJson(response['data'][i]));
      }
      print('length of magazine category is  ${magazines.length}');
      setState(() {
        
      });
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
