import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_categories.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';

class MoreMagazines extends StatefulWidget {
  final MagazineCategory? magazineCategory;
  const MoreMagazines({super.key, this.magazineCategory});

  @override
  State<MoreMagazines> createState() => _MoreMagazinesState();
}

class _MoreMagazinesState extends State<MoreMagazines> {
  int currentPage = 1;
  List<EpaperModel> papers = [];
  EpaperServices epaperServices = EpaperServices();
  bool loadingPapers = true;
  @override
  void initState() {
    super.initState();
    initializeFetching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.magazineCategory!.name)),
      body: RefreshIndicator(
        onRefresh: () async {
          loadingPapers = true;
          currentPage = 0;
          initializeFetching();
          // Timer.periodic(Duration(seconds: 1), (t) {
          //   if (t == 1) {

          //   }
          // });
        },
        child: GridView.builder(
          // padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            mainAxisExtent: 300,
            childAspectRatio: 3,
          ),
          // physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: papers.isEmpty
              ? 2
              : papers.length < 6
              ? papers.length
              : 6,
          // itemCount: 30,
          // separatorBuilder: (context, index) => SizedBox(height: 15),
          itemBuilder: (BuildContext context, int index) {
            if (papers.isEmpty) return LoadingCard(height: 200);
            EpaperModel paper = papers[index];
            return paper.source_type == 'website' ? URLepaper(epaperModel: paper) : PDFepaper(epaperModel: paper);
          },
        ),
      ),
    );
  }

  initializeFetching() async {
    papers.clear();

    await epaperServices.getMagazines(category_id: widget.magazineCategory!.id).then((value) {
      Map<String, dynamic> response = {};

      response = jsonDecode(value.body);
      // print(response['data']);
      for (int i = 0; i < response['data'].length; i++) {
        papers.add(EpaperModel.fromJson(response['data'][i]));
      }
      print('length of all papers links is  ${papers.length} current pg:${currentPage}');
      currentPage++;
      loadingPapers = false;
    });
    setState(() {});
  }
}
