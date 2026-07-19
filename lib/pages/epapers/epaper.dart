import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/epaperModel.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WebEpaper extends StatefulWidget {
  const WebEpaper({super.key});

  @override
  State<WebEpaper> createState() => _WebEpaperState();
}

class _WebEpaperState extends State<WebEpaper> with AutomaticKeepAliveClientMixin{
  List<EpaperModel> webPapers = [];
  ScrollController? controller;

  @override
  void initState() {
    initializePapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<EpaperBloc>();

    return ep.loading
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : Scaffold(
            body: GridView.builder(
              controller: controller,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1),
              itemCount: webPapers.length,
              itemBuilder: (BuildContext context, int index) {
                var singlePaper = webPapers[index];
                return urlEpaperList(singlePaper);
                // return singlePaper.runtimeType == EpaperModel ? urlEpaperList(singlePaper) : urlItemList(singlePaper);
              },
            ),
          );
  }

  void initializePapers() {
    final cb = context.read<EpaperBloc>();
    cb.getWebData(mounted).whenComplete(() {
      for (var element in cb.data) {
        webPapers.add(element);
      }
    });
  }

  Widget urlEpaperList(EpaperModel paper) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'),fit: BoxFit.cover),
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).primaryColorDark.withValues(alpha: .1),
          //     Theme.of(context).scaffoldBackgroundColor,
          //     Theme.of(context).primaryColorDark.withValues(alpha: .3),
          //   ],
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          // ),
          
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 3), color: Theme.of(context).shadowColor)],
        ),
        child: Stack(
          children: [
            Hero(
              tag: paper.title!,
              child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
            ),
            Center(child: LineIcon.newspaper(size: 40)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                // decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'))),
                margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                child: Text(
                  paper.title!,
                  // '${data['link']}${HelperClass().getDate(DateTime.now())}',
                  style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // print('${HelperClass.mediaIp}${paper.cover_image!}');
        // launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
        launchPaper(paper);
      },
    );
  }

  // Widget urlItemList(Map data) {
  //   return InkWell(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             Theme.of(context).primaryColorDark.withValues(alpha: .1),
  //             Theme.of(context).scaffoldBackgroundColor,
  //             Theme.of(context).primaryColorDark.withValues(alpha: .3),
  //           ],
  //           begin: Alignment.bottomCenter,
  //           end: Alignment.topCenter,
  //         ),
  //         borderRadius: BorderRadius.circular(5),
  //         boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 3), color: Theme.of(context).shadowColor)],
  //       ),
  //       child: Stack(
  //         children: [
  //           Hero(
  //             tag: data['link'],
  //             child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
  //           ),
  //           Center(child: LineIcon.newspaper(size: 40)),
  //           Align(
  //             alignment: Alignment.bottomLeft,
  //             child: Container(
  //               margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
  //               child: Text(
  //                 data['name'].toString(),
  //                 // '${data['link']}${HelperClass().getDate(DateTime.now())}',
  //                 style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
  //     },
  //   );
  // }

  void launchPaper(EpaperModel epaperModel) async {
    print(epaperModel.website_url!);
    final uri = Uri.parse(epaperModel.website_url!);
    if (await canLaunchUrl(uri)) {
      // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      AppService().openLinkWithCustomTab(context, epaperModel.website_url!);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // void launchPdfViewer(EpaperModel paper) async {
  //   String url = '${HelperClass.mediaIp}${paper.filepath}';
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
}
