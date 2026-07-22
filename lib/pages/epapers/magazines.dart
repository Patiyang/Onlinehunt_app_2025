import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/magazine_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';

class Magazines extends StatefulWidget {
  const Magazines({super.key});

  @override
  State<Magazines> createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> with AutomaticKeepAliveClientMixin {
  List<EpaperModel> magazines = [];
  ScrollController? controller;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<MagazineBloc>().onRefresh(mounted);
    });
    super.initState();
  }

  void _scrollListener() {
    // final db = context.read<MagazineBloc>();

    // if (!db.loading) {
    //   if (controller!.position.pixels == controller!.position.maxScrollExtent) {
    //     db.setLoading(true);
    //     db.getData(mounted);
    //   }
    // }
  }
  @override
  Widget build(BuildContext context) {
    final ep = context.watch<MagazineBloc>();
    // final epr = context.read<MagazineBloc>();

    return ep.loading
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await ep.onRefresh(mounted);
              },
              child: GridView.builder(
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1),
                itemCount: ep.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var singlePaper = ep.data[index];
                  return singlePaper.source_type == 'website' ?URLepaper(epaperModel: singlePaper,) : PDFepaper(epaperModel:singlePaper);
                  // return singlePaper.runtimeType == EpaperModel ? urlEpaperList(singlePaper) : urlItemList(singlePaper);
                },
              ),
            ),
          );
  }

  Widget urlEpaperList({EpaperModel ?epaperModel}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 3), color: Theme.of(context).shadowColor)],
        ),
        child: Stack(            alignment: Alignment.center,

          children: [
            Hero(
              tag: epaperModel!.title!,
              child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
            ),
           ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: '${HelperClass.mediaIp}${epaperModel!.cover_image!}',
                placeholder: (context, url) => Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) {
                  return Image.asset(Config().splashIcon, height: 120, width: 120, fit: BoxFit.cover);
                },
              ),
            ),   Container(
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
                // decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}'))),
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
                child: epaperModel.source_type == 'website' ? Icon(Icons.link) : Icon(Icons.picture_as_pdf),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // print('${HelperClass.mediaIp}${paper.source_type!}');
        // launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
        // launchPaper(paper);
      },
    );
  }

  Widget pdfEpaperList({EpaperModel ?epaperModel}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${paper.cover_image!}')),
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
          alignment: Alignment.center,
          // fit: StackFit.passthrough,
          children: [
            // Hero(
            //   tag: paper.title!,
            //   child: Container(width: MediaQuery.of(context).size.width, child: SizedBox.shrink()),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '${HelperClass.mediaIp}${epaperModel!.cover_image!}',
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
                child: epaperModel.source_type == 'website' ? Icon(Icons.link) : Icon(Icons.picture_as_pdf),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print('${HelperClass.mediaIp}${epaperModel.source_type!}');
        // launchPdfViewer(paper);
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
