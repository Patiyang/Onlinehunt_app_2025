import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/blocs/periodicals_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyEpaper extends StatefulWidget {
  const DailyEpaper({super.key});

  @override
  State<DailyEpaper> createState() => _DailyEpaperState();
}

class _DailyEpaperState extends State<DailyEpaper> with AutomaticKeepAliveClientMixin {
  List<EpaperModel> webPapers = [];
  // List<EpaperModel> PDFPapers = [];

  ScrollController? controller;

  @override
  void initState() {
    // initializePapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dp = context.watch<DailyPeriodicalBloc>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 23,
                width: 4,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  // fp.getApiData(mounted, context);
                },
                child: Text('daily', style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold)).tr(),
              ),
              Spacer(),
              // TextButton(
              //   child: Text('view all', style: TextStyle(color: Theme.of(context).primaryColorDark)).tr(),
              //   onPressed: () => nextScreen(context, MoreArticles(title: 'featured news')),
              // ),
            ],
          ),
        ),
        dp.loading == true
            ? Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15), child: LoadingCard(height: 200))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: dp.data.isEmpty ? 2 : dp.data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    // EpaperModel paper =fp.data.isEmpty?EpaperModel(): fp.data[index];

                    return dp.data.isEmpty
                        ? LoadingCard(height: 300, width: 210)
                        : dp.data[index].source_type == 'website'
                        ? URLepaper(epaperModel:dp.data[index], customUrl:true)
                        : PDFepaper(epaperModel: dp.data[index]);
                  },
                ),
              ),
      ],
    );
  }

  void initializePapers() {
    final cb = context.read<DailyPeriodicalBloc>();
    cb.getData(mounted).whenComplete(() {
      for (var element in cb.data) {
        webPapers.add(element);
      }
    });
  }

  Widget urlEpaperList({EpaperModel ?epaperModel, customUrl=false}) {
      return Hero(
      tag: epaperModel!.title!,

      child: InkWell(
        child: Container(
          height: 300,
          width: 210,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            // image: DecorationImage(image: CachedNetworkImageProvider('${HelperClass.mediaIp}${epaperModel.cover_image!}'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color: Theme.of(context).iconTheme.color!.withValues(alpha: .2))],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
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
                  // decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('${HelperClass.mediaIp}${epaperModel.cover_image!}'))),
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
                  child: Icon(Icons.link),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // print('${HelperClass.mediaIp}${epaperModel.cover_image!}');
          // launchPaper('${data['link']}${HelperClass().getDate(DateTime.now())}&page=1&url=home&ced=14');
          launchPaper(epaperModel);
        },
      ),
    );
  }

  void launchPaper(EpaperModel epaperModel) async {
    print(epaperModel.website_url!);
    final uri = Uri.parse(updateUrlWithToday(epaperModel.website_url!));
    if (await canLaunchUrl(uri)) {
      print(updateUrlWithToday(epaperModel.website_url!));
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      // AppService().openLinkWithCustomTab(context, updateUrlWithToday(epaperModel.website_url!));
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  String updateUrlWithToday(String url) {
    final uri = Uri.parse(url);

    // Format today's date as dd/MM/yyyy
    final today = HelperClass().getDate(DateTime.now().subtract(Duration(days: 1)));

    // Copy existing query parameters
    final params = Map<String, String>.from(uri.queryParameters);

    // Update values
    params['date'] = today;
    params['page'] = '1';

    // Build the query manually so '/' isn't encoded
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return '${uri.scheme}://${uri.host}${uri.path}?$query';
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
