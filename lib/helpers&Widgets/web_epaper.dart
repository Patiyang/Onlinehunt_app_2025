import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:url_launcher/url_launcher.dart';

class URLepaper extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? customUrl;
  final EpaperModel epaperModel;

  const URLepaper({super.key, required this.epaperModel, this.height = 300, this.width = 210, this.customUrl = false});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: epaperModel.title!,

      child: InkWell(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            // image: DecorationImage(image: CachedNetworkImageProvider('${HelperClass.mediaIp}${epaperModel.cover_image!}'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, offset: Offset(1, 2), color:  Theme.of(context).shadowColor)],
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

          if (customUrl == true) {            launchDailyPaper(epaperModel, context);

          } else {            launchPaper(epaperModel, context);

          }
        },
      ),
    );
  }

  void launchPaper(EpaperModel epaperModel, BuildContext context) async {
    print(epaperModel.website_url!);
    final uri = Uri.parse(epaperModel.website_url!);
    if (await canLaunchUrl(uri)) {
      // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      AppService().openLinkWithCustomTab(context, epaperModel.website_url!);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  void launchDailyPaper(EpaperModel epaperModel, BuildContext context) async {
    print(epaperModel.website_url!);
    final uri = Uri.parse(updateUrlWithToday(epaperModel.website_url!));
    if (await canLaunchUrl(uri)) {
      print(updateUrlWithToday(epaperModel.website_url!));
      // await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      AppService().openLinkWithCustomTab(context, updateUrlWithToday(epaperModel.website_url!));
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  String updateUrlWithToday(String url) {
    final uri = Uri.parse(url);

    // Format today's date as dd/MM/yyyy
    final today = HelperClass().getDate(DateTime.now().subtract(Duration(days: 0)));

    // Copy existing query parameters
    final params = Map<String, String>.from(uri.queryParameters);

    // Update values
    params['date'] = today;
    params['page'] = '1';

    // Build the query manually so '/' isn't encoded
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return '${uri.scheme}://${uri.host}${uri.path}?$query';
  }
}
