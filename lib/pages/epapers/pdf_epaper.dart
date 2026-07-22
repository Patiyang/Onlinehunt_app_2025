// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:online_hunt_news/blocs/epaper_bloc.dart';
// import 'package:online_hunt_news/helpers&Widgets/loading.dart';
// import 'package:online_hunt_news/helpers&Widgets/pdf_epaper.dart';
// import 'package:online_hunt_news/models/epaper_model.dart';
// import 'package:provider/provider.dart';

// class PDFEpapers extends StatefulWidget {
//   const PDFEpapers({super.key});

//   @override
//   State<PDFEpapers> createState() => _PDFEpapersState();
// }

// class _PDFEpapersState extends State<PDFEpapers> with AutomaticKeepAliveClientMixin {
//   List<EpaperModel> PDFPapers = [];
  
//   ScrollController? controller;

//   @override
//   void initState() {
//     initializePapers();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ep = context.watch<EpaperBloc>();

//     return ep.loadingPDF
//         ? Center(
//             child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
//           )
//         : Scaffold(
//             body: RefreshIndicator(
//               onRefresh: () async {
//                 ep.onPDFRefresh(mounted);
//               },
//               child: GridView.builder(
//                 controller: controller,
//                 physics: AlwaysScrollableScrollPhysics(),
//                 padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1),
//                 itemCount: PDFPapers.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   var singlePaper = PDFPapers[index];
//                   return PDFepaper(epaperModel: singlePaper,);
//                   // return singlePaper.runtimeType == EpaperModel ? urlEpaperList(singlePaper) : urlItemList(singlePaper);
//                 },
//               ),
//             ),
//           );
//   }

//   void initializePapers() {
//     final cb = context.read<EpaperBloc>();
//     cb.getPDFData(mounted).whenComplete(() {
//       for (var element in cb.PDFdata) {
//         PDFPapers.add(element);
//       }
//     });
//   }

  // Widget pdfEpaperList(EpaperModel paper) {
  //   return Hero(
  //     tag: paper.title!,
  //     child: InkWell(
  //       child: Container(
  //         decoration: BoxDecoration(
  //           // image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'), fit: BoxFit.cover),
  //           // gradient: LinearGradient(
  //           //   colors: [
  //           //     Theme.of(context).primaryColorDark.withValues(alpha: .1),
  //           //     Theme.of(context).scaffoldBackgroundColor,
  //           //     Theme.of(context).primaryColorDark.withValues(alpha: .3),
  //           //   ],
  //           //   begin: Alignment.bottomCenter,
  //           //   end: Alignment.topCenter,
  //           // ),
  //           borderRadius: BorderRadius.circular(5),
  //           color: Theme.of(context).scaffoldBackgroundColor,

  //           boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).iconTheme.color!.withValues(alpha: .2))],
  //         ),
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             // Hero(
  //             //   tag: paper.title!,
  //             //   child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
  //             // ),
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(5),
  //               child: CachedNetworkImage(
  //                 fit: BoxFit.cover,
  //                 imageUrl: '${HelperClass.mediaIp}${paper.cover_image!}',
  //                 placeholder: (context, url) => Container(color: Colors.grey[300]),
  //                 errorWidget: (context, url, error) {
  //                   return Image.asset(Config().splashIcon, height: 120, width: 120, fit: BoxFit.cover);
  //                 },
  //               ),
  //             ),
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(5),
  //                 gradient: LinearGradient(
  //                   colors: [Theme.of(context).primaryColorLight.withValues(alpha: .7), Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .5)],
  //                   begin: Alignment.bottomCenter,
  //                   end: Alignment.topCenter,
  //                 ),
  //               ),
  //             ),
  //             Align(
  //               alignment: Alignment.bottomLeft,
  //               child: Container(
  //                 // decoration: BoxDecoration(image: ),
  //                 margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
  //                 child: Text(
  //                   paper.title!,
  //                   // '${data['link']}${HelperClass().getDate(DateTime.now())}',
  //                   style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6, fontSize: 18),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       onTap: () {
  //         // launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
  //         launchPdfViewer(paper);
  //       },
  //     ),
  //   );
  // }

  // void launchPdfViewer(EpaperModel paper) async {
  //   String url = '${HelperClass.mediaIp}${paper.pdf_file}';
  //   print(url);
  //   // print(url);
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  //     AppService().openLinkWithCustomTab(context, url);
  //   } else {
  //     debugPrint('Could not launch WhatsApp');
  //   }
  // }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
