import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:http/http.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/services/PDFService.dart';
import 'package:provider/provider.dart';

class OfflinePdfViewer extends StatefulWidget {
  final PDFItemModel pdfItemModel;
  const OfflinePdfViewer({super.key, required this.pdfItemModel});

  @override
  State<OfflinePdfViewer> createState() => _OfflinePdfViewerState();
}

class _OfflinePdfViewerState extends State<OfflinePdfViewer> {
   bool pdf_ready = false;
  int currentPage = 1;
  int totalPages = 0;
  String? localPdfPath;

  @override
  void initState() {
    super.initState();
      _loadPdf();
  }
  @override
  Widget build(BuildContext context) {
    final tm = context.read<ThemeBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.pdfItemModel.title!)),

      body:localPdfPath==null?Loading(): Stack(
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
          ).fromPath(localPdfPath!),
            pdf_ready == false
                          ? SizedBox.shrink()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: Card(
                                  // padding: const EdgeInsets.all(18.0),
                                  // margin: EdgeInsets.all(10),
                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), col),
                                  child: Container(margin: EdgeInsets.all(10), child: Text('${"page".tr()} $currentPage ${"of".tr()} $totalPages')),
                                ),
                              ),
                            ),
        ],
      ),
    );
  }
  Future<void> _loadPdf() async {
  localPdfPath = await PDFService().getPDFPath(
    widget.pdfItemModel.file_name,
  );

  if (mounted) {
    setState(() {});
  }
}
}
