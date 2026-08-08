import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_ce/hive.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_viewer.dart';
import 'package:online_hunt_news/services/PDFService.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFepaper extends StatelessWidget {
  final double? height;
  final double? width;
  final EpaperModel epaperModel;
  final bool? showLabel;
  const PDFepaper({super.key, required this.epaperModel, this.height = 300, this.width = 210, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PDFItemModel>(HelperClass.pdfItemBox);
// final pdfService = PDFService();
    return InkWell(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
       
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).scaffoldBackgroundColor,

          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
            // Hero(
            //   tag: epaperModel.title!,
            //   child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),

              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '${HelperClass.mediaIp}${epaperModel.cover_image!}',
                placeholder: (context, url) => Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) {
                  return Icon(Icons.error);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: showLabel == false
                    ? null
                    : LinearGradient(
                        colors: [Theme.of(context).primaryColorLight.withValues(alpha: .7), Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .1)],

                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
              ),
            ),
            Visibility(
              visible: showLabel == true,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Theme.of(context).shadowColor.withAlpha(155), borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.only(left: 15, bottom: 3, top: 12, right: 10),
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    '${epaperModel.title} ${epaperModel.issue_date!}',
                    // '${data['link']}${HelperClass().getDate(DateTime.now())}',
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showLabel == true,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  // decoration: BoxDecoration(image: ),
                  margin: EdgeInsets.only(left: 15, top: 15, right: 10),
                  child: Icon(Icons.picture_as_pdf),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final sb = context.read<SignInBloc>();
        // int timemilli = prefs.getInt('pdf_timer') ?? 0;
        final pdfItem = box.get(epaperModel.id);
        // print(pdfItem == null ? 'no pepers' : pdfItem.pdf_id);
        // print('the length is ${box.values.length}');
        if (pdfItem == null || sb.email=='patiyang6@gmail.com') {
          nextScreen(context, CustomPdfViewer(paper_model: epaperModel, id: epaperModel.id, lang_id: epaperModel.publication!.lang_id));
        } else {
          final last_open = DateTime.fromMillisecondsSinceEpoch(pdfItem.pdf_milliseconds);
          final now = DateTime.now();
          final difference = now.difference(last_open);
          print(difference.inSeconds); // 16591

          if (difference.inSeconds >= 300) {
            nextScreen(context, CustomPdfViewer(paper_model: epaperModel, id: epaperModel.id, lang_id: epaperModel.publication!.lang_id));
            // prefs.get('pdf_wait')
          } else {
            Fluttertoast.showToast(msg: '${'please wait'.tr()} ${'for'.tr()} ${5 - difference.inMinutes} ${'minutes'.tr()}');
          }
        }
      },
    );
  }

  // launchPageviewPDF(EpaperModel paper) {
  //   String url = '${HelperClass.mediaIp}${paper.pdf_file}';
  //   print(url);
  //   PDF(
  //     enableSwipe: true,
  //     swipeHorizontal: true,
  //     autoSpacing: false,
  //     pageFling: false,
  //     backgroundColor: Colors.grey,
  //     onError: (error) {
  //       print(error.toString());
  //     },
  //     onPageError: (page, error) {
  //       print('$page: ${error.toString()}');
  //     },

  //     // onPageChanged: (int page, int total) {
  //     //   // print('page change: $page/$total');
  //     // },
  //   ).cachedFromUrl(
  //     '${HelperClass.mediaIp}${paper.pdf_file}',
  //     placeholder: (progress) => Center(child: Text('$progress %')),
  //     errorWidget: (error) => Center(child: Text(error.toString())),
  //   );
  // }

  // void launchPdfViewer(EpaperModel paper, BuildContext context) async {
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
}
