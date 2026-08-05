import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CutomEpaperViewer extends StatefulWidget {
  final EpaperModel? paper_model;
  final int? id;
  final int? lang_id;
  final bool? customUrl;
  const CutomEpaperViewer({super.key, this.paper_model, this.id, this.lang_id, this.customUrl = false});

  @override
  State<CutomEpaperViewer> createState() => _CutomEpaperViewerState();
}

class _CutomEpaperViewerState extends State<CutomEpaperViewer> {
  bool loading = true;
  EpaperModel? epaperModel;
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    checkModelPresence(widget.id!, widget.lang_id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: loading == true ? 0 : Theme.of(context).appBarTheme.toolbarHeight,
        title: loading == true ? SizedBox.shrink() : Text(epaperModel!.title!),
        actions: [
          IconButton(
            onPressed: () {
              HelperClass().handleContentShare(context, null, epaperModel: epaperModel);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: loading == true ? Loading(text: 'please wait'.tr()) : Container(child: WebViewWidget(controller: controller!)),
    );
  }

  void checkModelPresence(int id, int lang_id) async {
    if (widget.paper_model == null) {
      await EpaperServices().getEpaper(id, lang_id).then((value) {
        Map<String, dynamic> response = jsonDecode(value!.body);
        EpaperModel data = EpaperModel.fromJson(response['data']);
        print(data.title);
        print('title of epaper links is  ${data!.title}');
        epaperModel = data;
        String url = widget.customUrl == true ? updateUrlWithToday(epaperModel!.website_url!) : epaperModel!.website_url!;
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url))
          ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
          ..canGoBack();

        // setState(() {});
      });
    } else {
      epaperModel = widget.paper_model;
      String url = /* widget.customUrl == true ? updateUrlWithToday(epaperModel!.website_url!) : */ epaperModel!.website_url!;

      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    }
    setState(() {
      loading = false;
    });
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
