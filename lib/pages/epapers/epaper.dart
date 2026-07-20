import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
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

class _WebEpaperState extends State<WebEpaper> with AutomaticKeepAliveClientMixin {
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
            body: RefreshIndicator(
              onRefresh: () async {
                ep.onRefresh(mounted);
              },
              child: GridView.builder(
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
    return Hero(
      tag: paper.title!,
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 3), color: Theme.of(context).shadowColor)],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${HelperClass.mediaIp}${paper.cover_image!}',
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
                    colors: [Theme.of(context).primaryColorLight.withValues(alpha: .7), Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .7)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  // decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'))),
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                  child: Text(
                    paper.title!,
                    // '${data['link']}${HelperClass().getDate(DateTime.now())}',
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6, fontSize: 18),
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
      ),
    );
  }

  void launchPaper(EpaperModel epaperModel) async {
    print(epaperModel.website_url!);
    final uri = Uri.parse(updateUrlWithToday(epaperModel.website_url!));
    if (await canLaunchUrl(uri)) {
      // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      AppService().openLinkWithCustomTab(context, epaperModel.website_url!);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  String updateUrlWithToday(String url) {
    final uri = Uri.parse(url);

    // Format today's date as dd/MM/yyyy
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Replace the date parameter
    final updatedParams = Map<String, String>.from(uri.queryParameters);
    updatedParams['date'] = today;

    return uri.replace(queryParameters: updatedParams).toString();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
