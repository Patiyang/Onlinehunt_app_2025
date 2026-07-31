import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/custom_color.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/models/metaModel.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

class MoreEpapers extends StatefulWidget {
  final String? periodType;
  final String? source_type;
  const MoreEpapers({super.key, this.periodType, this.source_type='website'});

  @override
  State<MoreEpapers> createState() => _MoreEpapersState();
}

class _MoreEpapersState extends State<MoreEpapers> {
  int currentPage = 1;

  int totalPages = 1;
  List<EpaperModel> papers = [];
  EpaperServices epaperServices = EpaperServices();
  bool loadingPapers = true;
  bool _isLoadingMore = false;
  NewspapersMetamodel? metaData;
  ScrollController scrollController = ScrollController();
  String? source_type;
  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange && _isLoadingMore == false) {
      print('loadingData');
      if (metaData!.total == papers.length) {
        print('no more data');
        return;
      } else {
        initializeFetching();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    initializeFetching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.periodType!).tr(),

        actions: [
          // PopupMenuButton<String?>(
          //   tooltip: 'View Options',
          //   icon: const Icon(Icons.filter_alt_outlined),
          //   onSelected: (value) {
          //     switch (value) {
          //       case 'null':
          //         source_type = null;
          //         print(source_type);
          //         handleRefresh();
          //         break;

          //       case 'pdf':
          //         // Open PDF
          //         source_type = value;
          //         print(source_type);
          //         handleRefresh();
          //         break;

          //       case 'website':
          //         // Open Website
          //         source_type = value;
          //         print(source_type);
          //         handleRefresh();
          //         break;
          //     }
          //   },
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       value: 'null',
          //       child: Row(children: [Icon(Icons.newspaper), SizedBox(width: 12), Text('all'.tr())]),
          //     ),
          //     PopupMenuItem(
          //       value: 'pdf',
          //       child: Row(children: [Icon(Icons.picture_as_pdf), SizedBox(width: 12), Text('pdfs'.tr())]),
          //     ),
          //     PopupMenuItem(
          //       value: 'website',
          //       child: Row(children: [Icon(Icons.language), SizedBox(width: 12), Text('web_papers'.tr())]),
          //     ),
          //   ],
          // ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          handleRefresh();
        },
        child: Stack(
          children: [
            GridView.builder(
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
              itemCount: papers.isEmpty ? 6 : papers.length + 1,
              // itemCount: 30,
              // separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (BuildContext context, int index) {
                if (index == papers.length) {
                  return _buildProgressIndicator();
                }
                if (papers.isEmpty)
                  return SkeletonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.watch<ThemeBloc>().darkTheme == false ? CustomColor().loadingColorLight : CustomColor().loadingColorDark,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 300,
                      // width: 210,
                    ),
                  );
                EpaperModel paper = papers[index];
                return paper.source_type == 'website' ? URLepaper(epaperModel: paper, customUrl: true) : PDFepaper(epaperModel: paper);
              },
            ),
            papers.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 25,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                      child: Center(
                        child: Text(
                          '${'page'.tr()} ${metaData!.currentPage} ${'of'.tr()} ${metaData!.totalPages}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  initializeFetching() async {
    setState(() {
      papers.clear();
    });

    if (widget.periodType == 'daily') {
      await epaperServices.getAllEpapers(page: currentPage, soure_type: widget.source_type!).then((value) {
        Map<String, dynamic> response = {};

        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          papers.add(EpaperModel.fromJson(response['data'][i]));
        }
        metaData = NewspapersMetamodel.fromJson(response['meta']);
        totalPages = metaData!.totalPages;
        print('length of all papers links is  ${papers.length} current pg:${currentPage}');
      });
      // if(totalPages)
      currentPage++;
      loadingPapers = false;
    } else {
      await epaperServices.getPeriodicals(widget.periodType!, soure_type: widget.source_type!).then((value) {
        Map<String, dynamic> response = {};

        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          papers.add(EpaperModel.fromJson(response['data'][i]));
        }
        metaData = NewspapersMetamodel.fromJson(response['meta']);
        totalPages = metaData!.totalPages;
        print('length of all papers links is  ${papers.length} current pg:${currentPage}');
      });
      currentPage++;
      loadingPapers = false;
    }
    setState(() {});
  }

  handleRefresh() {
    loadingPapers = true;
    currentPage = 1;
    initializeFetching();
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 300,
      width: 210,
      child: new Center(
        child: new Opacity(opacity: _isLoadingMore ? 1.0 : 0.0, child: new Loading()),
      ),
    );
  }

  Widget markSource(String? type) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: source_type != type ? Colors.blue : Theme.of(context).primaryColor),
      height: 10,
      width: 10,
    );
  }
}
