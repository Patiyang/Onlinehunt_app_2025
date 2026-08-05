import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_ce/hive.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:online_hunt_news/services/PDFService.dart';
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
  final pdfService = PDFService();
  // final box = Hive.box<PDFItemModel>('pdfs');
  final box = Hive.box<PDFItemModel>(HelperClass.pdfItemBox);
  bool is_downloaded = false;
  bool _isDownloading = false;
  double progress = 0;
  bool pdf_ready = false;
  int currentPage = 1;
  int totalPages = 0;
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
          // IconButton(
          //   onPressed: () {
          //     // HelperClass().handleContentShare(context, null, epaperModel: epaperModel);
          //     handleDownload();
          //   },
          //   icon: Icon(is_downloaded ? Icons.download_done : Icons.download),
          // )
          IconButton(
            onPressed: () {
              HelperClass().handleContentShare(context, null, epaperModel: epaperModel);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      floatingActionButton: pdf_ready == false && _isDownloading==false
          ? SizedBox.shrink()
          : TextButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
                iconColor: WidgetStatePropertyAll(Theme.of(context).iconTheme.color),
                textStyle: WidgetStatePropertyAll(TextStyle(color: Theme.of(context).iconTheme.color)),
              ),
              onPressed: () => handleDownload(),
              label: Text(is_downloaded ? "delete" : 'save').tr(),
              icon: Icon(is_downloaded ? Icons.delete : Icons.save, size: 25),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: loading == true
          ? Loading(text: 'please wait'.tr())
          : Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
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
                        fitEachPage: true,
                        onPageError: (page, error) {
                          print('$page: ${error.toString()}');
                        },

                        onPageChanged: (int? page, int? total) {
                          page = (page! + 1);
                          currentPage = page;
                          totalPages = total!;
                          setState(() {});
                          print('page change: ${page}/$total');
                        },
                        onRender: (int? pages) {
                          print('render pages$pages');
                          totalPages = pages!;
                          pdf_ready = true;
                          setState(() {});
                        },
                        onViewCreated: (controller) {
                          // print(controller.)
                        },
                      ).cachedFromUrl(
                        maxAgeCacheObject: Duration(days: 365),
                        '${HelperClass.mediaIp}${epaperModel!.pdf_file}',
                        placeholder: (progress) => Center(child: Text('$progress %')),
                        errorWidget: (error) => Center(child: Text(error.toString())),
                      ),
             pdf_ready == false ? SizedBox.shrink() :         Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Card(
                            // padding: const EdgeInsets.all(18.0),
                            // margin: EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), col),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child:  Text('${"page".tr()} $currentPage ${"of".tr()} $totalPages'),
                            ),
                          ),
                        ),
                      ),
                      _isDownloading ? LinearProgressIndicator(value: progress, backgroundColor: Config().appColor) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
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
    checkDownloadStatus();
    setState(() {
      loading = false;
    });
  }

  void initializeHive() async {
    final box = await Hive.box<PDFItemModel>(HelperClass.pdfItemBox);
    // Hive.openBox(HelperClass.pdfItemBox);
    final pdfItem = PDFItemModel(pdf_id: epaperModel!.id!, pdf_milliseconds: DateTime.now().millisecondsSinceEpoch, pdf_original_name: epaperModel!.title);

    await box.put(pdfItem.pdf_id, pdfItem);
  }

  checkDownloadStatus() {
    final item = box.get(epaperModel!.id);
    // box.values.where(test)
    final existing = item != null && item.file_name != null && item.file_name!.isNotEmpty;
    is_downloaded = existing;
    setState(() {});
  }

  handleDownload() async {
    if (is_downloaded == false) {
      setState(() {
        _isDownloading = true;
        progress = 0.0;
      });
      final fileName = await pdfService.downloadPDF(
        pdfId: epaperModel!.id!,
        url: '${HelperClass.mediaIp}${epaperModel!.pdf_file}',
        onProgress: (value) {
          setState(() {
            progress = value;
          });
        },
      );
      setState(() {
        _isDownloading = false;
      });
      final item = PDFItemModel(
        pdf_id: epaperModel!.id!,
        pdf_milliseconds: DateTime.now().millisecondsSinceEpoch,
        file_name: fileName,
        pdf_original_name: epaperModel!.title,
      );

      await box.put(epaperModel!.id!, item);
      Fluttertoast.showToast(msg: 'pdf_downloaded'.tr());
    } else {
      final item = box.get(epaperModel!.id!);

      if (item != null) {
        await PDFService().deletePDF(epaperModel!.id!);

        item.file_name = null;

        await item.save();
        Fluttertoast.showToast(msg: 'pdf_deleted'.tr());
      }
    }

    checkDownloadStatus();
  }
}
