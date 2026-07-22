import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_viewer.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFepaper extends StatelessWidget {
    final double ?height;
  final double ?width;
  final EpaperModel epaperModel;
  const PDFepaper( {super.key, required this.epaperModel, this.height=300, this.width=210});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: epaperModel.title!,
      child: InkWell(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            // image: DecorationImage(image: CachedNetworkImageProvider('${HelperClass.mediaIp}${epaperModel.cover_image!}'), fit: BoxFit.cover),
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
            color: Theme.of(context).scaffoldBackgroundColor,

            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).shadowColor)],
          ),
          child: Stack(
            alignment: Alignment.center,
            // fit: StackFit.passthrough,
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
                    return Image.asset(Config().splashIcon, height: 120, width: 120, fit: BoxFit.cover);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColorLight.withValues(alpha: .7), Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .5)],

                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  // decoration: BoxDecoration(image: ),
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                  child: Text(
                    epaperModel.title!,
                    // '${data['link']}${HelperClass().getDate(DateTime.now())}',
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6, fontSize: 18),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  // decoration: BoxDecoration(image: ),
                  margin: EdgeInsets.only(left: 15, top: 15, right: 10),
                  child: Icon(Icons.picture_as_pdf),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
          // launchPdfViewer(epaperModel, context);
          // launchPageviewPDF(epaperModel);
          //            String url = '${HelperClass.mediaIp}${epaperModel.pdf_file}';
          // print(url);
          nextScreen(context, CustomPdfViewer(paper_model: epaperModel,));
        },
      ),
    );
  }

  launchPageviewPDF(EpaperModel paper) {
    String url = '${HelperClass.mediaIp}${paper.pdf_file}';
    print(url);
    PDF(
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      backgroundColor: Colors.grey,
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
      '${HelperClass.mediaIp}${paper.pdf_file}',
      placeholder: (progress) => Center(child: Text('$progress %')),
      errorWidget: (error) => Center(child: Text(error.toString())),
    );
  }

  void launchPdfViewer(EpaperModel paper, BuildContext context) async {
    String url = '${HelperClass.mediaIp}${paper.pdf_file}';
    print(url);
    // print(url);
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      AppService().openLinkWithCustomTab(context, url);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }
}
