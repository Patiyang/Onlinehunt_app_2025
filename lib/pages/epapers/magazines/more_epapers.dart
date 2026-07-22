import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';

class MoreEpapers extends StatefulWidget {
  final String? periodType;
  const MoreEpapers({super.key, this.periodType});

  @override
  State<MoreEpapers> createState() => _MoreEpapersState();
}

class _MoreEpapersState extends State<MoreEpapers> {
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
      appBar: AppBar(title: Text(widget.periodType!).tr()),

      body: RefreshIndicator(
        onRefresh: () async {
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
            mainAxisSpacing: 8,
            crossAxisSpacing: 15,
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
    if (widget.periodType == 'daily') {
      await epaperServices.getAllEpapers().then((value) {
        Map<String, dynamic> response = {};

        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          papers.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of all papers links is  ${papers.length}');
        currentPage++;
        loadingPapers = false;
      });
    } else {
      await epaperServices.getPeriodicals(widget.periodType!).then((value) {
        Map<String, dynamic> response = {};

        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          papers.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of all papers links is  ${papers.length}');
      });
      currentPage++;
      loadingPapers = false;
    }
    setState(() {});
  }
}
