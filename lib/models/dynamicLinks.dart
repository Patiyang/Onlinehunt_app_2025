// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  // Future<Uri> createDynamicLink(String? id, String categoryId, String description, String title, String imageUrl, {String type = ''}) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       uriPrefix: 'https://onlinehuntnews.page.link',
  //       link: Uri.parse('https://onlinehuntnews.page.link.com/?id=$id&categoryId=$categoryId'),
  //       androidParameters: AndroidParameters(
  //         packageName: 'com.onlinehunt.app',
  //         minimumVersion: 1,
  //       ),
  //       iosParameters: IOSParameters(
  //         bundleId: 'your_ios_bundle_identifier',
  //         minimumVersion: '1',
  //         appStoreId: 'your_app_store_id',
  //       ),
  //       socialMetaTagParameters: SocialMetaTagParameters(description: description, title: title, imageUrl: Uri.parse(imageUrl)));
  //   var dynamicUrl = await parameters.link.toString();
  //   final Uri shortUrl = Uri.parse(dynamicUrl);
  //   return shortUrl;
  // }

  // Future<Uri> createDynamicLinkIptv(String? id, String url, String title) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       uriPrefix: 'https://onlinehuntnews.page.link',
  //       link: Uri.parse('https://onlinehuntnews.page.link.com/?id=$id&type=iptv'),
  //       androidParameters: AndroidParameters(
  //         packageName: 'com.onlinehunt.app',
  //         minimumVersion: 1,
  //       ),
  //       iosParameters: IOSParameters(
  //         bundleId: 'your_ios_bundle_identifier',
  //         minimumVersion: '1',
  //         appStoreId: 'your_app_store_id',
  //       ),
  //       socialMetaTagParameters: SocialMetaTagParameters(
  //           description: url,
  //           title: title,
  //           imageUrl: Uri.parse(
  //             'https://onlinehunt.in/news/uploads/logo/splash.png',
  //           )));
  //   var dynamicUrl = await parameters.link.toString();
  //   final Uri shortUrl = Uri.parse(dynamicUrl);
  //   return shortUrl;
  // }

  // Future<void> retrieveDynamicLink(BuildContext context) async {
  //   try {
  //     FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //         try {
  //           print('onlink success ${dynamicLink!.link.queryParameters}');
  //           if (dynamicLink.link.queryParameters.containsKey('id')) {
  //             String? id = dynamicLink.link.queryParameters['id'];
  //             String? category = dynamicLink.link.queryParameters['categoryId'];
  //             String? type = dynamicLink.link.queryParameters['type'] ?? 'article';
  //             ApiArticle article = await getApiArticleById(id);
  //             // navigateToDetailsScreen(context, article, '', category!);
  //             print('the type is $type');
  //             if (type == 'iptv') {
  //               Fluttertoast.showToast(msg: 'msg');
  //            Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => IptvVideo(
  //                             id: id,
  //                           )));
  //             } else {
  //               Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => ArticleDetails(
  //                         articleId: id,
  //                         data: null,
  //                         tag: '',
  //                         categoryId: category,
  //                       )));
  //             }
  //           }
  //         } catch (e) {
  //           print('onLinkError is ' + e.toString());
  //         }
  //       },
  //       onError: (OnLinkErrorException e) async {
  //         print('onLinkError is ${e.message}');
  //       },
  //     );
  //     // }
  //   } catch (e) {
  //     print('THE OVERAL ERROR IS ${e.toString()}');
  //   }
  // }

  // Future<ApiArticle> getApiArticleById(String id) async {
  //   List response = [];
  //   List<ApiArticle> articles = [];
  //   await PostServices().getPosts('single_post', count: 'allArticles', id: id).then((value) {
  //     response = jsonDecode(utf8.decode(value.bodyBytes));
  //   }).whenComplete(() {
  //     for (int i = 0; i < response.length; i++) {
  //       articles.add(ApiArticle.fromJson(response[i]));
  //     }
  //   });

  //   return articles.where((element) => element.id == id ? true : false).first;
  // }
}
