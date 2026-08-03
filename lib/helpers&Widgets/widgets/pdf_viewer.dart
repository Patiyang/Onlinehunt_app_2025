import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_ce/hive.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPdfViewer extends StatefulWidget {
  final EpaperModel? paper_model;
  final int? id;
  final int? lang_id;
  const CustomPdfViewer({super.key, this.paper_model, this.id, this.lang_id});

  @override
  State<CustomPdfViewer> createState() => _CustomPdfViewerState();
}

class _CustomPdfViewerState extends State<CustomPdfViewer> {
  bool loading = true;
  EpaperModel? epaperModel;
  @override
  void initState() {
    super.initState();
    checkModelPresence(widget.id!, widget.lang_id!);
  }

  @override
  Widget build(BuildContext context) {
    final tm = context.read<ThemeBloc>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: loading == true ? 0 : Theme.of(context).appBarTheme.toolbarHeight,
        title: loading == true ? SizedBox.shrink() : Text(epaperModel!.title!),
        actions: [
          IconButton(
            onPressed: () {
              HelperClass().handleContentShare(context, null, epaperModel: epaperModel);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: loading == true
          ? Loading(text: 'please wait'.tr())
          : Container(
              child:
                  PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageSnap: true,
                    nightMode: tm.darkTheme == true ? true : false,
                    // pageFling: false,
                    // backgroundColor: Colors.blue,
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },

                    // onPageChanged: (int page, int total) {
                    //   // print('page change: $page/$total');
                    // },
                  ).cachedFromUrl(
                    '${HelperClass.mediaIp}${epaperModel!.pdf_file}',
                    placeholder: (progress) => Center(child: Text('$progress %')),
                    errorWidget: (error) => Center(child: Text(error.toString())),
                  ),
            ),
    );
  }

  checkModelPresence(int id, int lang_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.paper_model == null) {
      await EpaperServices().getEpaper(id, lang_id).then((value) {
        Map<String, dynamic> response = jsonDecode(value!.body);
        EpaperModel data = EpaperModel.fromJson(response['data']);
        print(data.title);
        print('title of epaper links is  ${data!.title}');
        epaperModel = data;
        setState(() {});
      });
    } else {
      epaperModel = widget.paper_model;
    }
    // prefs.setInt('pdf_timer', DateTime.now().millisecondsSinceEpoch);
    initializeHive();
    setState(() {
      loading = false;
    });
  }

  void initializeHive() async {
    final box = Hive.box<PDFItemModel>(HelperClass.pdfItemBox);

    final pdfItem = PDFItemModel(pdf_id: epaperModel!.id!, pdf_milliseconds: DateTime.now().millisecondsSinceEpoch);

    await box.put(pdfItem.pdf_id, pdfItem);
  }
}
