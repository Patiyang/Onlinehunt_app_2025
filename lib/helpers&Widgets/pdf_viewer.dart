import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/epaper_model.dart';

class CustomPdfViewer extends StatefulWidget {
  final EpaperModel? paper_model;
  const CustomPdfViewer({super.key, this.paper_model});

  @override
  State<CustomPdfViewer> createState() => _CustomPdfViewerState();
}

class _CustomPdfViewerState extends State<CustomPdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.paper_model!.title!),),
      body:
          Container(
            child: PDF(
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageSnap: true,
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
              '${HelperClass.mediaIp}${widget.paper_model!.pdf_file}',
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            ),
          ),
    );
  }
}
