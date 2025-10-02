import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/full_image.dart';
import 'package:html/dom.dart' as dom;

// final String demoText = "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>" +
// //'''<iframe width="560" height="315" src="https://www.youtube.com/embed/-WRzl9L4z3g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'''+
// '''<video controls src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"></video>''' +
// "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>";

class HtmlBodyWidget extends StatelessWidget {
  final String htmlData;
  const HtmlBodyWidget({Key? key, required this.htmlData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !htmlData.contains('<p>')
        ? Text(htmlData, style: TextStyle(fontSize: 17))
        : Html(
            data: '''${htmlData}''',
            onLinkTap: (String? url, Map<String, String> attributes, _) {
              AppService().openLinkWithCustomTab(context, url!);
            },
            // onAnchorTap: (String? url, Map<String, String> attributes, _) {
            //   nextScreen(context, FullScreenImage(imageUrl: url!));
            // },
            extensions: [
              OnImageTapExtension(
                onImageTap: (String? src, Map<String, String> imgAttributes, dom.Element? element) {
                  if (src != null && src.isNotEmpty) {
                    nextScreen(context, FullScreenImage(imageUrl: src));
                  }
                },
              ),
              TagExtension(
                tagsToExtend: {'img'},
                builder: (ctx) {
                  final src = ctx.attributes['src'];
                  return src != null
                      ? InkWell(
                          child: Hero(
                            tag: src,
                            child: Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: CachedNetworkImageProvider(src), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          onTap: () => nextScreen(context, FullScreenImage(imageUrl: src)),
                        )
                      : const SizedBox();
                },
              ),
            ],
            style: {
              "body": Style(margin: Margins.all(0), padding: HtmlPaddings.all(0), fontSize: FontSize(15.0), lineHeight: LineHeight(1.4)),
              "figure": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
              "h2": Style(letterSpacing: -0.7, wordSpacing: 0.5),
            },
            // onlyRenderTheseTags: {
            //   "img",
            //   "video/mp4"
            //       "iframe",
            // },
          );
  }
}
