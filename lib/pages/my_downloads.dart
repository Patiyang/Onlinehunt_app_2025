import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/services/PDFService.dart';
import 'package:online_hunt_news/utils/empty.dart';

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
      appBar: AppBar(),
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
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).scaffoldBackgroundColor,

                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
                  ),
                  child: Text(pdf.pdf_original_name ?? ''),
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
