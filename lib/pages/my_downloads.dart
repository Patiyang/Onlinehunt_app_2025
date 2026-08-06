import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/offline_pdf_viewer.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/services/PDFService.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:online_hunt_news/utils/next_screen.dart';

class MyDownloads extends StatefulWidget {
  const MyDownloads({super.key});

  @override
  State<MyDownloads> createState() => _MyDownloadsState();
}

class _MyDownloadsState extends State<MyDownloads> {
  List<PDFItemModel>? downloads;
  PDFService pdfService = PDFService();
  @override
  void initState() {
    super.initState();
    getLocalPdfs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(downloads == null ? '--' : downloads![0].title!)),
      body: downloads == null
          ? Loading()
          : downloads!.isEmpty
          ? EmptyPage(icon: Icons.download, message: 'no_downloads', message1: '')
          : GridView.builder(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              itemCount: downloads!.length,

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 15,
                mainAxisExtent: 300,
                childAspectRatio: 3,
              ),
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                final pdf = downloads![index];

                return FutureBuilder(
                  future: PDFService().getThumbnailPath(pdf.thumbnail_name),
                  // initialData: InitialData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(pdf.thumbnail_name);
                    // Fluttertoast.showToast(msg: snapshot.data);
                    // return ;
                    return GestureDetector(
                      onTap: () {
                        // pdfService.downloadCoverImage(pdfId: pdfId, imageUrl: imageUrl)
                        nextScreen(context, OfflinePdfViewer(pdfItemModel: pdf));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).scaffoldBackgroundColor,

                          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
                        ),
                        child: Stack(
                          fit: StackFit.passthrough,

                          children: [
                            snapshot.hasData
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(File(snapshot.data!), width: 70, fit: BoxFit.cover),
                                  )
                                : Image.asset(Config().splashIcon, height: 120, width: 120, fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColorLight.withValues(alpha: .7),
                                    Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .1),
                                  ],

                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: Theme.of(context).shadowColor.withAlpha(155), borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.only(left: 15, bottom: 3, top: 12, right: 10),
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  '${pdf.title} ${pdf.issue_date!}',
                                  // '${data['link']}${HelperClass().getDate(DateTime.now())}',
                                  style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
                                ),
                              ),
                            ),
                            // Text(pdf.title ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

      // ListView.builder(
      //     itemCount: downloads!.length,
      //     itemBuilder: (context, index) {
      //       final pdf = downloads![index];

      //       return ListTile(title: Text('PDF ${pdf.pdf_id} and name '), subtitle: Text(pdf.pdf_original_name ?? ''));
      //     },
      //   ),
    );
  }

  void getLocalPdfs() async {
    downloads = await pdfService.getDownloadedPDFs();
    setState(() {});
  }
}
